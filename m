Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab1CPMet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 08:34:49 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:53185 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab1CPMel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 08:34:41 -0400
X-IronPort-AV: E=Sophos;i="4.63,194,1299456000"; 
   d="scan'208";a="4817470"
Date: Wed, 16 Mar 2011 12:34:10 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Ian Campbell <ijc@hellion.org.uk>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Allen Kay <allen.m.kay@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: [RFC PATCH] set current_state to D0 in
 register_slot
In-Reply-To: <1299601032.17339.525.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.DEB.2.00.1103161230570.3382@kaball-desktop>
References: <alpine.DEB.2.00.1102281605130.2917@kaball-desktop>  <20110304104251.45b257c4@jbarnes-desktop>  <1299595858.17339.512.camel@zakaz.uk.xensource.com> <1299601032.17339.525.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse,
do you have any comments on the following patch?
Also, are you OK with taking "set current_state to D0 in register_slot"
in your tree? Otherwise should I send a pull request to Linus with the
patch and your ack?
Cheers,

Stefano

On Tue, 8 Mar 2011, Ian Campbell wrote:
> From 5cb5d576e7177762abe29cfba3f616c48e619145 Mon Sep 17 00:00:00 2001
> From: Ian Campbell <ian.campbell@citrix.com>
> Date: Tue, 8 Mar 2011 16:16:34 +0000
> Subject: [PATCH] acpiphp: assume device is in state D0 after powering on a slot.
> 
> Devices which do not support PCI configuration space based power
> management may not otherwise be enabled.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> ---
>  drivers/pci/hotplug/acpiphp_glue.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> index e610cfe..a502fef 100644
> --- a/drivers/pci/hotplug/acpiphp_glue.c
> +++ b/drivers/pci/hotplug/acpiphp_glue.c
> @@ -827,6 +827,13 @@ static int __ref enable_device(struct acpiphp_slot *slot)
>  	acpiphp_set_hpp_values(bus);
>  	acpiphp_set_acpi_region(slot);
>  	pci_enable_bridges(bus);
> +
> +	list_for_each_entry(dev, &bus->devices, bus_list) {
> +		/* Assume that newly added devices are powered on already. */
> +		if (!dev->is_added)
> +			dev->current_state = PCI_D0;
> +	}
> +
>  	pci_bus_add_devices(bus);
>  
>  	list_for_each_entry(func, &slot->funcs, sibling) {
> -- 
> 1.5.6.5
> 
> 
> 
> -- 
> Ian Campbell
> Current Noise: Behemoth - Daimonos
> 
> Unix is a Registered Bell of AT&T Trademark Laboratories.
> 		-- Donn Seeley
> 
> 
