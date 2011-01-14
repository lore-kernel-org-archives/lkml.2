Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab1ANNH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 08:07:28 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:50817 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757153Ab1ANNHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 08:07:20 -0500
X-Sasl-enc: AMgVbhxSI2mqNwjxMMHdXf7Am/WiY4g0Ejcv1nQtbRsd 1295010439
Message-ID: <4D304A84.1000601@fastmail.fm>
Date: Fri, 14 Jan 2011 13:07:16 +0000
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-GB; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@st.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, shawn.bohrer@gmail.com
Subject: Re: [PATCH resend] fs/eventpoll.c: fix compilation warning
References: <1295005953-12173-1-git-send-email-viresh.kumar@st.com>
In-Reply-To: <1295005953-12173-1-git-send-email-viresh.kumar@st.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc Al Viro and Shawn Bohrer]
On 14/01/2011 11:52, Viresh Kumar wrote:
> This patch fixes following compilation warning
> fs/eventpoll.c:1119: warning: 'slack' may be used uninitialized in this function
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> ---
>  fs/eventpoll.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index 8cf0724..89b5e98 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1116,7 +1116,7 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
>  {
>  	int res, eavail, timed_out = 0;
>  	unsigned long flags;
> -	long slack;
> +	long uninitialized_var(slack);
>  	wait_queue_t wait;
>  	struct timespec end_time;
>  	ktime_t expires, *to = NULL;

Hi Viresh,

This is certainly the correct thing to do if timeout cannot be negative.

Al, Shawn

Can timeout be negative, and if so what does it mean?

Thanks,

Jack
