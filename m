Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab2HNSfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 14:35:00 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45755 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab2HNSe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 14:34:59 -0400
Date: Tue, 14 Aug 2012 11:34:54 -0700
From: Tejun Heo <tj@kernel.org>
To: Joonsoo Kim <js1304@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/6] workqueue: correct req_cpu in
 trace_workqueue_queue_work()
Message-ID: <20120814183454.GV25632@google.com>
References: <Yes>
 <1344967816-1136-1-git-send-email-js1304@gmail.com>
 <1344967816-1136-3-git-send-email-js1304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344967816-1136-3-git-send-email-js1304@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Aug 15, 2012 at 03:10:12AM +0900, Joonsoo Kim wrote:
> When we do tracing workqueue_queue_work(), it records requested cpu.
> But, if !(@wq->flag & WQ_UNBOUND) and @cpu is WORK_CPU_UNBOUND,
> requested cpu is changed as local cpu.
> In case of @wq->flag & WQ_UNBOUND, above change is not occured,
> therefore it is reasonable to correct it.
>
> Use temporary local variable for storing local cpu.
> 
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 49d8f4a..6a17ab0 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1198,6 +1198,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
>  	struct cpu_workqueue_struct *cwq;
>  	struct list_head *worklist;
>  	unsigned int work_flags;
> +	unsigned int lcpu;

@lcpu in __queue_delayed_work() stands for "last cpu", which is kinda
weird here.  Maybe just add "unsigned int req_cpu = cpu" at the top of
the function and use it for the TP?

Thanks.

-- 
tejun
