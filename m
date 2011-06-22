Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab1FVHLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 03:11:38 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:45500 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab1FVHLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 03:11:37 -0400
Date: Wed, 22 Jun 2011 12:41:12 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Nikhil Rao <ncrao@google.com>
Subject: Re: [patch 08/16] sched: throttle cfs_rq entities which exceed their
 local runtime
Message-ID: <20110622071112.GB2985@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20110621071649.862846205@google.com>
 <20110621071700.494088365@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110621071700.494088365@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 12:16:57AM -0700, Paul Turner wrote:
> @@ -1505,7 +1559,17 @@ enqueue_task_fair(struct rq *rq, struct 
>  			break;
>  		cfs_rq = cfs_rq_of(se);
>  		enqueue_entity(cfs_rq, se, flags);
> +
> +		/*
> +		 * end evaluation on encountering a throttled cfs_rq
> +		 *
> +		 * note: in the case of encountering a throttled cfs_rq we will
> +		 * post the final h_nr_running decrement below.

You mean 'final h_nr_running increment' I suppose ?

> +		*/
> +		if (cfs_rq_throttled(cfs_rq))
> +			break;
>  		cfs_rq->h_nr_running++;
> +
>  		flags = ENQUEUE_WAKEUP;
>  	}
> 
> @@ -1513,11 +1577,15 @@ enqueue_task_fair(struct rq *rq, struct 
>  		cfs_rq = cfs_rq_of(se);
>  		cfs_rq->h_nr_running++;

Regards,
Bharata.
