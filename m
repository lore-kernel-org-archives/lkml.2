Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab0K0TAb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 14:00:31 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:33868 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab0K0TA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 14:00:29 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 27 Nov 2010 10:58:32 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@davide-lnx1
To: Shawn Bohrer <shawn.bohrer@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier.adi@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] epoll: initialize slack for negative timeout values
In-Reply-To: <1290655909-10616-1-git-send-email-shawn.bohrer@gmail.com>
Message-ID: <alpine.DEB.2.00.1011271057110.28998@davide-lnx1>
References: <AANLkTi=oTq3_-7OZZwGrYjQPXA0TCDFB_DaFXJ7rvWH9@mail.gmail.com> <1290655909-10616-1-git-send-email-shawn.bohrer@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-620284592-1290884317=:28998"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-620284592-1290884317=:28998
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 24 Nov 2010, Shawn Bohrer wrote:

> When a negative timeout value is passed to epoll the 'slack' variable is
> currently uninitialized:
> 
> fs/eventpoll.c: In function ‘ep_poll’:
> fs/eventpoll.c:1119: warning: ‘slack’ may be used uninitialized in this function
> 
> In this case a NULL pointer is passed to schedule_hrtimeout_range()
> specifying an infinite timeout.  The current implementation of
> schedule_hrtimeout_range() does not use slack in this case, but we
> should still initialize slack to 0 in case future implementations use it.

Thanks.


> Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>

Acked-by: Davide Libenzi <davidel@xmailserver.org>



> ---
>  fs/eventpoll.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index 8cf0724..c24a032 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1116,7 +1116,7 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
>  {
>  	int res, eavail, timed_out = 0;
>  	unsigned long flags;
> -	long slack;
> +	long slack = 0;
>  	wait_queue_t wait;
>  	struct timespec end_time;
>  	ktime_t expires, *to = NULL;



- Davide


--8323329-620284592-1290884317=:28998--
