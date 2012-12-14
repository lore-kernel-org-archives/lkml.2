Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab2LNQpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:45:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26663 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799Ab2LNQpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:45:44 -0500
X-Authority-Analysis: v=2.0 cv=Jaw+XD2V c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=aMxrRGBvQbYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=cAgnu1O8zo8A:10 a=QyXUC8HyAAAA:8 a=l6TdlRWzQdANE4CJKAwA:9 a=PUjeQqilurYA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355503542.17101.398.camel@gandalf.local.home>
Subject: [PATCH] staging: Enable parport sb105x drivers if parport is
 configured
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>
Date: Fri, 14 Dec 2012 11:45:42 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the drivers that the sb105x SystemBase handles are for parallel
port cards. If PARPORT isn't configured, the build fails. Only
initialize the parallel port cards if PARPORT is configured in.

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


diff --git a/drivers/staging/sb105x/sb_pci_mp.c b/drivers/staging/sb105x/sb_pci_mp.c
index edb2a85..131afd0c 100644
--- a/drivers/staging/sb105x/sb_pci_mp.c
+++ b/drivers/staging/sb105x/sb_pci_mp.c
@@ -3054,6 +3054,7 @@ static int init_mp_dev(struct pci_dev *pcidev, mppcibrd_t brd)
 				sbdev->nr_ports = ((portnum_hex/16)*10) + (portnum_hex % 16);
 			}
 			break;
+#ifdef CONFIG_PARPORT
 		case PCI_DEVICE_ID_MP2S1P :
 			sbdev->nr_ports = 2;
 
@@ -3073,6 +3074,7 @@ static int init_mp_dev(struct pci_dev *pcidev, mppcibrd_t brd)
 			/* add PC compatible parallel port */
 			parport_pc_probe_port(pcidev->resource[2].start, pcidev->resource[3].start, PARPORT_IRQ_NONE, PARPORT_DMA_NONE, &pcidev->dev, 0);
 			break;
+#endif
 	}
 
 	ret = request_region(sbdev->uart_access_addr, (8*sbdev->nr_ports), sbdev->name);


