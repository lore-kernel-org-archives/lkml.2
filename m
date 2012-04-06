Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab2DFELY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 00:11:24 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10608 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab2DFELW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 00:11:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 05 Apr 2012 21:11:22 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: stern@rowland.harvard.edu, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH v2] usb: host: tegra: re-arranging ehci functions
Date: Fri,  6 Apr 2012 09:40:18 +0530
Message-Id: <1333685418-20801-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-arranged EHCI generic and tegra specific functions
into two separate groups for more readability.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---

 drivers/usb/host/ehci-tegra.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 3de48a2..9ab7a9e 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -552,31 +552,32 @@ static const struct hc_driver tegra_ehci_hc_driver = {
 	.description		= hcd_name,
 	.product_desc		= "Tegra EHCI Host Controller",
 	.hcd_priv_size		= sizeof(struct ehci_hcd),
-
 	.flags			= HCD_USB2 | HCD_MEMORY,
 
-	.reset			= tegra_ehci_setup,
+	/* standard ehci functions */
 	.irq			= ehci_irq,
-
 	.start			= ehci_run,
 	.stop			= ehci_stop,
-	.shutdown		= tegra_ehci_shutdown,
 	.urb_enqueue		= ehci_urb_enqueue,
 	.urb_dequeue		= ehci_urb_dequeue,
-	.map_urb_for_dma	= tegra_ehci_map_urb_for_dma,
-	.unmap_urb_for_dma	= tegra_ehci_unmap_urb_for_dma,
 	.endpoint_disable	= ehci_endpoint_disable,
 	.endpoint_reset		= ehci_endpoint_reset,
 	.get_frame_number	= ehci_get_frame,
 	.hub_status_data	= ehci_hub_status_data,
-	.hub_control		= tegra_ehci_hub_control,
 	.clear_tt_buffer_complete = ehci_clear_tt_buffer_complete,
+	.relinquish_port	= ehci_relinquish_port,
+	.port_handed_over	= ehci_port_handed_over,
+
+	/* modified ehci functions for tegra */
+	.reset			= tegra_ehci_setup,
+	.shutdown		= tegra_ehci_shutdown,
+	.map_urb_for_dma	= tegra_ehci_map_urb_for_dma,
+	.unmap_urb_for_dma	= tegra_ehci_unmap_urb_for_dma,
+	.hub_control		= tegra_ehci_hub_control,
 #ifdef CONFIG_PM
 	.bus_suspend		= tegra_ehci_bus_suspend,
 	.bus_resume		= tegra_ehci_bus_resume,
 #endif
-	.relinquish_port	= ehci_relinquish_port,
-	.port_handed_over	= ehci_port_handed_over,
 };
 
 static int setup_vbus_gpio(struct platform_device *pdev)
-- 
1.7.1.1

