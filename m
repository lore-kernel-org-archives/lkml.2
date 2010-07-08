Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416Ab0GHRtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 13:49:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:56622 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758219Ab0GHRtS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 13:49:18 -0400
Subject: Re: [PATCH] sched: Call update_group_power only for local_group
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venkatesh Pallipadi <venki@google.com>,
       LKML <linux-kernel@vger.kernel.org>, Gautham R Shenoy <ego@in.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Michael Neuling <mikey@neuling.org>
In-Reply-To: <1278611133.2834.10.camel@sbs-t61.sc.intel.com>
References: <1278088816.1917.279.camel@laptop>
	 <1278089799-11949-1-git-send-email-venki@google.com>
	 <1278598336.1900.150.camel@laptop>
	 <1278611133.2834.10.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 08 Jul 2010 19:49:06 +0200
Message-ID: <1278611346.1900.165.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 10:45 -0700, Suresh Siddha wrote:
>  
> @@ -2456,6 +2454,9 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
>  	init_sd_power_savings_stats(sd, sds, idle);
>  	load_idx = get_sd_load_idx(sd, idle);
>  
> +	if (this_cpu == smp_processor_id())
> +		update_group_power(sd, this_cpu);
> +
>  	do {
>  		int local_group;

Which will break for nohz_idle_balance..
