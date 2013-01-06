Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab3AFD2G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 22:28:06 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:47873 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133Ab3AFD2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 22:28:05 -0500
Date: Sat, 5 Jan 2013 22:28:03 -0500 (EST)
From: CAI Qian <caiqian@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linda Wang <lwang@redhat.com>, Matt Zywusko <mzywusko@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <1020130360.779.1357442883266.JavaMail.root@redhat.com>
In-Reply-To: <20130105181313.GB13076@redhat.com>
Subject: Re: [PATCH 1/2] signals: sys_ssetmask() uses uninitialized newmask
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.13.37]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Oleg Nesterov" <oleg@redhat.com>
> To: "CAI Qian" <caiqian@redhat.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Linus Torvalds"
> <torvalds@linux-foundation.org>
> Cc: "Linda Wang" <lwang@redhat.com>, "Matt Zywusko" <mzywusko@redhat.com>, "Al Viro" <viro@zeniv.linux.org.uk>,
> linux-kernel@vger.kernel.org
> Sent: Sunday, January 6, 2013 2:13:13 AM
> Subject: [PATCH 1/2] signals: sys_ssetmask() uses uninitialized newmask
> 
> 77097ae5 "most of set_current_blocked() callers want SIGKILL/SIGSTOP
> removed from set" removed the initialization of newmask by accident,
> restore.
> 
> Reported-by: CAI Qian <caiqian@redhat.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Cc: stable@kernel.org	# v3.5+
Thanks Oleg. This is now passing the testing.

Tested-by: CAI Qian <caiqian@redhat.com>
> ---
>  kernel/signal.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 7aaa51d..9692499 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -3286,6 +3286,7 @@ SYSCALL_DEFINE1(ssetmask, int, newmask)
>  	int old = current->blocked.sig[0];
>  	sigset_t newset;
>  
> +	siginitset(&newset, newmask);
>  	set_current_blocked(&newset);
>  
>  	return old;
> --
> 1.5.5.1
> 
> 
> 
