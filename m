Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792Ab1FGSSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:18:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757010Ab1FGSSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:18:03 -0400
Date: Tue, 7 Jun 2011 20:16:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2 1/2] coredump: use task comm instead of (unknown)
Message-ID: <20110607181607.GA3732@redhat.com>
References: <1307457010-7241-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307457010-7241-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07, Jiri Slaby wrote:
>
> @@ -1631,7 +1631,7 @@ static int cn_print_exe_file(struct core_name *cn)
>
>  	exe_file = get_mm_exe_file(current->mm);
>  	if (!exe_file)
> -		return cn_printf(cn, "(unknown)");
> +		return cn_printf(cn, "%s (path unknown)", current->comm);

Hmm. The patch itself looks fine to me.

Acked-by: Oleg Nesterov <oleg@redhat.com>



But the code looks wrong.

What if d_path() fails with, say, ENAMETOOLONG? do_coredump() doesn't
expect an error code != ENOMEM. This is just ugly, I'll send the simple
fix. Anyway, if we are changing cn_print_exe_file(), perhaps it makes
sense to fallback if d_path fails too?

And, I am just noticed...

	for (p = path; *p; p++)
		if (*p == '/')
			*p = '!';

Why??? I am not arguing, just curious.

Oleg.

