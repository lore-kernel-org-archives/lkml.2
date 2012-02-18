Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab2BRU4m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 15:56:42 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41831 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab2BRU4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 15:56:37 -0500
Date: Sat, 18 Feb 2012 21:56:26 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
        linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] fs: hardlink creation restrictions
Message-ID: <20120218205626.GA26880@joi.lan>
References: <20120218193857.GA30985@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120218193857.GA30985@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 18, 2012 at 11:38:57AM -0800, Kees Cook wrote:
> @@ -3052,6 +3119,9 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
>  	error = mnt_want_write(new_path.mnt);
>  	if (error)
>  		goto out_dput;
> +	error = may_linkat(&old_path);
> +	if (error)
> +		goto out_dput;
>  	error = security_path_link(old_path.dentry, &new_path, new_dentry);
>  	if (error)
>  		goto out_drop_write;

You should give up write access after check failure (i.e. goto out_drop_write).

Marcin
