Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab1AOTGG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 14:06:06 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:48923 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab1AOTGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 14:06:04 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 15 Jan 2011 11:06:04 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@davide-lnx1
To: Shawn Bohrer <shawn.bohrer@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Jack Stone <jwjstone@fastmail.fm>, Viresh Kumar <viresh.kumar@st.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 1/3] epoll: initialize slack for negative timeout
 values
In-Reply-To: <1295110837-3061-1-git-send-email-shawn.bohrer@gmail.com>
Message-ID: <alpine.DEB.2.00.1101151104260.6884@davide-lnx1>
References: <20110115162027.GA2552@lintop> <1295110837-3061-1-git-send-email-shawn.bohrer@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-300727794-1295118289=:6884"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-300727794-1295118289=:6884
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

On Sat, 15 Jan 2011, Shawn Bohrer wrote:

> When a negative timeout value is passed to epoll the 'slack' variable is
> currently unitialized:
> 
> fs/eventpoll.c: In function ¡ep_poll¢:
> fs/eventpoll.c:1119: warning: ¡slack¢ may be used uninitialized in this function
> 
> In this case a NULL pointer is passed to schedule_hrtimeout_range()
> specifying an infinite timeout.  The current implementation of
> schedule_hrtimeout_range() does not use slack in this case, but we
> should still initialize slack to 0 in case future implementations use it.
> 
> Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
> Acked-by: Davide Libenzi <davidel@xmailserver.org>
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

Re-ACK.
But, I am consolidating 1 and (a rewritten) 2, into a single one, since 
they would otherwise conflict with another patch.



- Davide

--8323329-300727794-1295118289=:6884--
