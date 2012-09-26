Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117Ab2IZSee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 14:34:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36912 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2IZSed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 14:34:33 -0400
Date: Wed, 26 Sep 2012 11:34:29 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Ray Jui <rjui@broadcom.com>
Subject: Re: [PATCH 05/12] workqueue: don't wake up other workers in rescuer
Message-ID: <20120926183429.GF12544@google.com>
References: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
 <1348680043-5077-6-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348680043-5077-6-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Ray Jui)

On Thu, Sep 27, 2012 at 01:20:36AM +0800, Lai Jiangshan wrote:
> rescuer is NOT_RUNNING, so there is no sense when it wakes up other workers,
> if there are available normal workers, they are already woken up when needed.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/workqueue.c |    8 --------
>  1 files changed, 0 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index c718b94..6c339bf 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -2438,14 +2438,6 @@ repeat:
>  
>  		process_scheduled_works(rescuer);
>  
> -		/*
> -		 * Leave this gcwq.  If keep_working() is %true, notify a
> -		 * regular worker; otherwise, we end up with 0 concurrency
> -		 * and stalling the execution.
> -		 */
> -		if (keep_working(pool))
> -			wake_up_worker(pool);
> -

This was added by 7576958a9d5a4a6 ("workqueue: wake up a worker when a
rescuer is leaving a gcwq") to fix a bug reported by Ray Jui.

  http://thread.gmane.org/gmane.linux.kernel/1098131

I'm fairly sure it was a valid bug report.  I don't think the
depletion comes from concurrency management.  It's just the lack of
chaining which could lead to stall.  What am I missing here?

Thanks.

-- 
tejun
