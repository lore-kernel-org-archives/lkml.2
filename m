Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966085Ab2JZTIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 15:08:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54205 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965423Ab2JZTIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 15:08:19 -0400
Date: Fri, 26 Oct 2012 20:08:16 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] VFS: add config options to enable link restrictions
Message-ID: <20121026190816.GS2616@ZenIV.linux.org.uk>
References: <20121026185021.GA1960@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121026185021.GA1960@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 11:50:21AM -0700, Kees Cook wrote:

> +config PROTECTED_SYMLINKS_SYSCTL
> +	int
> +	default "1" if PROTECTED_SYMLINKS
> +	default "0"

If anything, use IS_ENABLED instead...

> -int sysctl_protected_symlinks __read_mostly = 0;
> -int sysctl_protected_hardlinks __read_mostly = 0;
> +int sysctl_protected_symlinks __read_mostly =
> +	CONFIG_PROTECTED_SYMLINKS_SYSCTL;
> +int sysctl_protected_hardlinks __read_mostly =
> +	CONFIG_PROTECTED_HARDLINKS_SYSCTL;


