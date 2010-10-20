Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab0JTHae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 03:30:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47708 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758470Ab0JTHae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 03:30:34 -0400
Date: Wed, 20 Oct 2010 09:30:27 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "hpa@zytor.com" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [PATCH 2/2]x86: spread tlb flush vector between nodes
Message-ID: <20101020073027.GA20124@basil.fritz.box>
References: <1287544023.4571.8.camel@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287544023.4571.8.camel@sli10-conroe.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shaohua,

> +	if (nr_online_nodes > NUM_INVALIDATE_TLB_VECTORS)
> +		nr_node_vecs = 1;
> +	else
> +		nr_node_vecs = NUM_INVALIDATE_TLB_VECTORS/nr_online_nodes;

Does this build without CONFIG_NUMA? AFAIK nr_online_nodes is only
defined for a numa kernel.

> +
> +static int tlb_cpuhp_notify(struct notifier_block *n,
> +		unsigned long action, void *hcpu)
> +{
> +	switch (action & 0xf) {
> +	case CPU_ONLINE:
> +	case CPU_DEAD:
> +		calculate_tlb_offset();

I still think the notifier is overkill and a static mapping at boot time
would be fine.

The rest looks ok to me.

-andi
