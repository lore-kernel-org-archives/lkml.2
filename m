Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242Ab1KWELF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 23:11:05 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53130 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042Ab1KWELE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 23:11:04 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4ECC7244.8060302@jp.fujitsu.com>
Date: Wed, 23 Nov 2011 13:10:44 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-pci@vger.kernel.org,
        Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH] PCI / Hotplug: Fix the ordering of operations in pcied_cleanup()
References: <201111222305.16077.rjw@sisk.pl>
In-Reply-To: <201111222305.16077.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've sent the patch to fix the problem a few weeks ago, and it is in
Jesse's -next tree.

Regards,
Kenji Kaneshige


(2011/11/23 7:05), Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki<rjw@sisk.pl>
> 
> Make pcied_cleanup() unregister the port service before
> destroying workqueues that are flushed during the port service
> unregistration.
> 
> Reported-by: Oliver Neukum<oneukum@suse.de>
> Signed-off-by: Rafael J. Wysocki<rjw@sisk.pl>
> ---
>   drivers/pci/hotplug/pciehp_core.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux/drivers/pci/hotplug/pciehp_core.c
> ===================================================================
> --- linux.orig/drivers/pci/hotplug/pciehp_core.c
> +++ linux/drivers/pci/hotplug/pciehp_core.c
> @@ -366,9 +366,9 @@ static int __init pcied_init(void)
>   static void __exit pcied_cleanup(void)
>   {
>   	dbg("unload_pciehpd()\n");
> +	pcie_port_service_unregister(&hpdriver_portdrv);
>   	destroy_workqueue(pciehp_ordered_wq);
>   	destroy_workqueue(pciehp_wq);
> -	pcie_port_service_unregister(&hpdriver_portdrv);
>   	info(DRIVER_DESC " version: " DRIVER_VERSION " unloaded\n");
>   }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

