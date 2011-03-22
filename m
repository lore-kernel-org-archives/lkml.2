Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab1CVLvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 07:51:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:15554 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab1CVLvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 07:51:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,224,1299484800"; 
   d="scan'208";a="406371828"
Date: Tue, 22 Mar 2011 12:51:35 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Kyungmin Park <kyungmin.park@samsung.com>, myungjoo.ham@gmail.com
Subject: Re: [PATCH v7] MAX8997/8966 MFD: Add IRQ control feature
Message-ID: <20110322115134.GF2351@sortiz-mobl>
References: <20110321135910.267f367f.sfr@canb.auug.org.au>
 <1300694904-29856-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300694904-29856-1-git-send-email-myungjoo.ham@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi MyungJoo,

On Mon, Mar 21, 2011 at 05:08:24PM +0900, MyungJoo Ham wrote:
> +static struct irq_chip max8997_irq_chip = {
> +	.name			= "max8997",
> +#ifdef CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED
> +	.irq_bus_lock		= max8997_irq_lock,
> +	.irq_bus_sync_unlock	= max8997_irq_sync_unlock,
> +	.irq_mask		= max8997_irq_mask,
> +	.irq_unmask		= max8997_irq_unmask,
> +#else /* CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED */
> +	.bus_lock		= max8997_irq_lock,
> +	.bus_sync_unlock	= max8997_irq_sync_unlock,
> +	.mask			= max8997_irq_mask,
> +	.unmask			= max8997_irq_unmask,
> +#endif /* CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED */
> +};
You actually don't need to define both pointer sets. Setting the irq_* ones
should be enough for both configs.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
