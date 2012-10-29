Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab2J2JrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 05:47:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:6297 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419Ab2J2JrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 05:47:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,670,1344236400"; 
   d="scan'208";a="241428197"
Date: Mon, 29 Oct 2012 11:47:13 +0200
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: Tejun Heo <tj@kernel.org>, Gustavo Padovan <gustavo@padovan.org>,
        linux-bluetooth@vger.kernel.org
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>, linux-kernel@vger.kernel.org,
        Konrad Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] workqueue: cancel_delayed_work() should return %NULL if
 work item is idle
Message-ID: <20121029094707.GC9314@aemeltch-MOBL1>
Mail-Followup-To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>,
	Tejun Heo <tj@kernel.org>, Gustavo Padovan <gustavo@padovan.org>,
	linux-bluetooth@vger.kernel.org,
	Dan Magenheimer <dan.magenheimer@oracle.com>,
	linux-kernel@vger.kernel.org, Konrad Wilk <konrad.wilk@oracle.com>
References: <444a6439-b1a4-4740-9e7e-bc37267cfe73@default>
 <20121018233928.GY13370@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121018233928.GY13370@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gustavo, could you apply the patch below to bluetooth-next tree, otherwise
it is deadly broken.

Best regards 
Andrei Emeltchenko 

On Thu, Oct 18, 2012 at 04:39:28PM -0700, Tejun Heo wrote:
> From e65120fcfc1cb9697655d29ecd7982451c05d3c2 Mon Sep 17 00:00:00 2001
> From: Dan Magenheimer <dan.magenheimer@oracle.com>
> Date: Thu, 18 Oct 2012 16:31:37 -0700
> 
> 57b30ae77b ("workqueue: reimplement cancel_delayed_work() using
> try_to_grab_pending()") made cancel_delayed_work() always return %true
> unless someone else is also trying to cancel the work item, which is
> broken - if the target work item is idle, the return value should be
> %false.
> 
> try_to_grab_pending() indicates that the target work item was idle by
> zero return value.  Use it for return.  Note that this brings
> cancel_delayed_work() in line with __cancel_work_timer() in return
> value handling.
> 
> Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> LKML-Reference: <444a6439-b1a4-4740-9e7e-bc37267cfe73@default>
> ---
>  kernel/workqueue.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index d951daa..042d221 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -2982,7 +2982,7 @@ bool cancel_delayed_work(struct delayed_work *dwork)
>  
>  	set_work_cpu_and_clear_pending(&dwork->work, work_cpu(&dwork->work));
>  	local_irq_restore(flags);
> -	return true;
> +	return ret;
>  }
>  EXPORT_SYMBOL(cancel_delayed_work);
>  
> -- 
> 1.7.7.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
