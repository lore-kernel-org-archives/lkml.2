Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab1J1BhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 21:37:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49654 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753900Ab1J1BhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 21:37:17 -0400
Message-ID: <4EAA070D.2020007@cn.fujitsu.com>
Date: Fri, 28 Oct 2011 09:36:13 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: FNST
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110322 Red Hat/3.1.9-3.el6_0 Thunderbird/3.1.9
MIME-Version: 1.0
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Carsten Emde <C.Emde@osadl.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, jslaby@suse.cz,
        Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] ipc:fix the wrong use of schedule_hrtimeout_range_clock()
References: <1316673323-5048-1-git-send-email-gaowanlong@cn.fujitsu.com>
In-Reply-To: <1316673323-5048-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-10-28 09:35:19,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-10-28 09:35:19,
	Serialize complete at 2011-10-28 09:35:19
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyone else should be added to cc?


On 09/22/2011 02:35 PM, Wanlong Gao wrote:

> Fix the wrong use of schedule_hrtimeout_range_clock() in wq_sleep(), although
> it is harmless for the syscall mq_timed* now.
> It's introduced by 9ca7d8e.
> 
> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> ---
>  ipc/mqueue.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index ed049ea..2e0ecfc 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -449,8 +449,8 @@ static int wq_sleep(struct mqueue_inode_info *info, int sr,
>  		set_current_state(TASK_INTERRUPTIBLE);
>  
>  		spin_unlock(&info->lock);
> -		time = schedule_hrtimeout_range_clock(timeout,
> -		    HRTIMER_MODE_ABS, 0, CLOCK_REALTIME);
> +		time = schedule_hrtimeout_range_clock(timeout, 0,
> +			HRTIMER_MODE_ABS, CLOCK_REALTIME);
>  
>  		while (ewp->state == STATE_PENDING)
>  			cpu_relax();


