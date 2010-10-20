Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab0JTIoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 04:44:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:36548 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab0JTIoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 04:44:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,354,1283756400"; 
   d="scan'208";a="338236231"
Subject: Re: [PATCH 2/2]x86: spread tlb flush vector between nodes
From: Shaohua Li <shaohua.li@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "hpa@zytor.com" <hpa@zytor.com>, "Chen, Tim C" <tim.c.chen@intel.com>
In-Reply-To: <20101020073027.GA20124@basil.fritz.box>
References: <1287544023.4571.8.camel@sli10-conroe.sh.intel.com>
	 <20101020073027.GA20124@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 16:44:22 +0800
Message-ID: <1287564262.8722.2.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 15:30 +0800, Andi Kleen wrote:
> Hi Shaohua,
> 
> > +	if (nr_online_nodes > NUM_INVALIDATE_TLB_VECTORS)
> > +		nr_node_vecs = 1;
> > +	else
> > +		nr_node_vecs = NUM_INVALIDATE_TLB_VECTORS/nr_online_nodes;
> 
> Does this build without CONFIG_NUMA? AFAIK nr_online_nodes is only
> defined for a numa kernel.
yes it's ok without CONFIG_NUMA

> > +
> > +static int tlb_cpuhp_notify(struct notifier_block *n,
> > +		unsigned long action, void *hcpu)
> > +{
> > +	switch (action & 0xf) {
> > +	case CPU_ONLINE:
> > +	case CPU_DEAD:
> > +		calculate_tlb_offset();
> 
> I still think the notifier is overkill and a static mapping at boot time
> would be fine.
this hasn't much overhead, so please keep it. I'm afraid static mapping
calculation for hotplug cpu will introduce more complex.

