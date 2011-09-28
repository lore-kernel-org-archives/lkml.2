Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab1I1EeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 00:34:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:62840 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab1I1EeK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 00:34:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="57377035"
From: "Zou, Yi" <yi.zou@intel.com>
To: Michael Chan <mchan@broadcom.com>,
        "Matt_Domsch@dell.com" <Matt_Domsch@dell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "devel@open-fcoe.org" <devel@open-fcoe.org>
Date: Tue, 27 Sep 2011 21:34:08 -0700
Subject: RE: [Open-FCoE] [PATCH] drivers/firmware/edd: Treat "XPRS" host bus
 type the same as "PCI"
Thread-Topic: [Open-FCoE] [PATCH] drivers/firmware/edd: Treat "XPRS" host
 bus type the same as "PCI"
Thread-Index: Acx9bF9Ghla40qDcRM2OzAqYrre/rAAKpNPA
Message-ID: <5A9BD224CEA58D4CB62235967D650C160EB7A807@orsmsx509.amr.corp.intel.com>
References: <1317162728-14488-1-git-send-email-mchan@broadcom.com>
In-Reply-To: <1317162728-14488-1-git-send-email-mchan@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> PCI Express devices will return "XPRS" host bus type during BIOS EDD
> call.  "XPRS" should be treated just like "PCI" so that the proper
> pci_dev symlink will be created.  Scripts such as fcoe-edd.sh will
> then work correctly.
> 
> Cc: Matt Domsch <Matt_Domsch@dell.com>
> Signed-off-by: Michael Chan <mchan@broadcom.com>

Patch looks good to me. Just a minor note, not to be picky, the script
you mentioned is actually called 'fcoe_edd.sh', not '-'.

Reviewed-by: Yi Zou <yi.zou@intel.com>


> ---
>  drivers/firmware/edd.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
> index f1b7f65..e229576 100644
> --- a/drivers/firmware/edd.c
> +++ b/drivers/firmware/edd.c
> @@ -151,7 +151,8 @@ edd_show_host_bus(struct edd_device *edev, char *buf)
>  		p += scnprintf(p, left, "\tbase_address: %x\n",
>  			     info->params.interface_path.isa.base_address);
>  	} else if (!strncmp(info->params.host_bus_type, "PCIX", 4) ||
> -		   !strncmp(info->params.host_bus_type, "PCI", 3)) {
> +		   !strncmp(info->params.host_bus_type, "PCI", 3) ||
> +		   !strncmp(info->params.host_bus_type, "XPRS", 4)) {
>  		p += scnprintf(p, left,
>  			     "\t%02x:%02x.%d  channel: %u\n",
>  			     info->params.interface_path.pci.bus,
> @@ -159,7 +160,6 @@ edd_show_host_bus(struct edd_device *edev, char *buf)
>  			     info->params.interface_path.pci.function,
>  			     info->params.interface_path.pci.channel);
>  	} else if (!strncmp(info->params.host_bus_type, "IBND", 4) ||
> -		   !strncmp(info->params.host_bus_type, "XPRS", 4) ||
>  		   !strncmp(info->params.host_bus_type, "HTPT", 4)) {
>  		p += scnprintf(p, left,
>  			     "\tTBD: %llx\n",
> @@ -668,7 +668,7 @@ edd_get_pci_dev(struct edd_device *edev)
>  {
>  	struct edd_info *info = edd_dev_get_info(edev);
> 
> -	if (edd_dev_is_type(edev, "PCI")) {
> +	if (edd_dev_is_type(edev, "PCI") || edd_dev_is_type(edev, "XPRS"))
> {
>  		return pci_get_bus_and_slot(info-
> >params.interface_path.pci.bus,
>  				     PCI_DEVFN(info-
> >params.interface_path.pci.slot,
>  					       info->params.interface_path.pci.
> --
> 1.7.1.GIT
> 
> 
> _______________________________________________
> devel mailing list
> devel@open-fcoe.org
> https://lists.open-fcoe.org/mailman/listinfo/devel
