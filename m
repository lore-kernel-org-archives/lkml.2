Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab1DEN2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 09:28:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:54519 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab1DEN21 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 09:28:27 -0400
Subject: Re: [patch 05/15] sched: unthrottle cfs_rq(s) who ran out of quota
 at period refresh
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Nikhil Rao <ncrao@google.com>
In-Reply-To: <20110323030449.142198821@google.com>
References: <20110323030326.789836913@google.com>
	 <20110323030449.142198821@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 05 Apr 2011 15:28:19 +0200
Message-ID: <1302010099.2225.1331.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-22 at 20:03 -0700, Paul Turner wrote:
> +#ifdef CONFIG_SMP
> +static inline const struct cpumask *sched_bw_period_mask(void)
> +{
> +       return cpu_rq(smp_processor_id())->rd->span;
> +}
> +#else
> +static inline const struct cpumask *sched_bw_period_mask(void)
> +{
> +       return cpu_online_mask;
> +}
> +#endif 

insert rant about merging cpusets into the sched and memcg
controllers :-)
