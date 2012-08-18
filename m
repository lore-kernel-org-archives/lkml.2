Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab2HRBGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 21:06:10 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:63886 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289Ab2HRBGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 21:06:00 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-209.messagelabs.com!1345251959!7747244!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/20] staging: comedi: adv_pci1710: convert boardinfo initialization to C99 format
Date: Fri, 17 Aug 2012 18:05:52 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208171805.53410.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the boardinfo initialization to C99 format to make it
less error prone.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adv_pci1710.c | 152 +++++++++++++++++++++------
 1 file changed, 118 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index 7f27c59..58de025 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -202,40 +202,124 @@ struct boardtype {
 };
 
 static const struct boardtype boardtypes[] = {
-	{"pci1710", 0x1710,
-	 IORANGE_171x, 1, TYPE_PCI171X,
-	 16, 8, 2, 16, 16, 1, 0x0fff, 0x0fff,
-	 &range_pci1710_3, range_codes_pci1710_3,
-	 &range_pci171x_da,
-	 10000, 2048},
-	{"pci1710hg", 0x1710,
-	 IORANGE_171x, 1, TYPE_PCI171X,
-	 16, 8, 2, 16, 16, 1, 0x0fff, 0x0fff,
-	 &range_pci1710hg, range_codes_pci1710hg,
-	 &range_pci171x_da,
-	 10000, 2048},
-	{"pci1711", 0x1711,
-	 IORANGE_171x, 1, TYPE_PCI171X,
-	 16, 0, 2, 16, 16, 1, 0x0fff, 0x0fff,
-	 &range_pci17x1, range_codes_pci17x1, &range_pci171x_da,
-	 10000, 512},
-	{"pci1713", 0x1713,
-	 IORANGE_171x, 1, TYPE_PCI1713,
-	 32, 16, 0, 0, 0, 0, 0x0fff, 0x0000,
-	 &range_pci1710_3, range_codes_pci1710_3, NULL,
-	 10000, 2048},
-	{"pci1720", 0x1720,
-	 IORANGE_1720, 0, TYPE_PCI1720,
-	 0, 0, 4, 0, 0, 0, 0x0000, 0x0fff,
-	 NULL, NULL, &range_pci1720,
-	 0, 0},
-	{"pci1731", 0x1731,
-	 IORANGE_171x, 1, TYPE_PCI171X,
-	 16, 0, 0, 16, 16, 0, 0x0fff, 0x0000,
-	 &range_pci17x1, range_codes_pci17x1, NULL,
-	 10000, 512},
-	/*  dummy entry corresponding to driver name */
-	{.name = DRV_NAME},
+	{
+		.name		= "pci1710",
+		.device_id	= 0x1710,
+		.iorange	= IORANGE_171x,
+		.have_irq	= 1,
+		.cardtype	= TYPE_PCI171X,
+		.n_aichan	= 16,
+		.n_aichand	= 8,
+		.n_aochan	= 2,
+		.n_dichan	= 16,
+		.n_dochan	= 16,
+		.n_counter	= 1,
+		.ai_maxdata	= 0x0fff,
+		.ao_maxdata	= 0x0fff,
+		.rangelist_ai	= &range_pci1710_3,
+		.rangecode_ai	= range_codes_pci1710_3,
+		.rangelist_ao	= &range_pci171x_da,
+		.ai_ns_min	= 10000,
+		.fifo_half_size	= 2048,
+	}, {
+		.name		= "pci1710hg",
+		.device_id	= 0x1710,
+		.iorange	= IORANGE_171x,
+		.have_irq	= 1,
+		.cardtype	= TYPE_PCI171X,
+		.n_aichan	= 16,
+		.n_aichand	= 8,
+		.n_aochan	= 2,
+		.n_dichan	= 16,
+		.n_dochan	= 16,
+		.n_counter	= 1,
+		.ai_maxdata	= 0x0fff,
+		.ao_maxdata	= 0x0fff,
+		.rangelist_ai	= &range_pci1710hg,
+		.rangecode_ai	= range_codes_pci1710hg,
+		.rangelist_ao	= &range_pci171x_da,
+		.ai_ns_min	= 10000,
+		.fifo_half_size	= 2048,
+	}, {
+		.name		= "pci1711",
+		.device_id	= 0x1711,
+		.iorange	= IORANGE_171x,
+		.have_irq	= 1,
+		.cardtype	= TYPE_PCI171X,
+		.n_aichan	= 16,
+		.n_aichand	= 0,
+		.n_aochan	= 2,
+		.n_dichan	= 16,
+		.n_dochan	= 16,
+		.n_counter	= 1,
+		.ai_maxdata	= 0x0fff,
+		.ao_maxdata	= 0x0fff,
+		.rangelist_ai	= &range_pci17x1,
+		.rangecode_ai	= range_codes_pci17x1,
+		.rangelist_ao	= &range_pci171x_da,
+		.ai_ns_min	= 10000,
+		.fifo_half_size	= 512,
+	}, {
+		.name		= "pci1713",
+		.device_id	= 0x1713,
+		.iorange	= IORANGE_171x,
+		.have_irq	= 1,
+		.cardtype	= TYPE_PCI1713,
+		.n_aichan	= 32,
+		.n_aichand	= 16,
+		.n_aochan	= 0,
+		.n_dichan	= 0,
+		.n_dochan	= 0,
+		.n_counter	= 0,
+		.ai_maxdata	= 0x0fff,
+		.ao_maxdata	= 0x0000,
+		.rangelist_ai	= &range_pci1710_3,
+		.rangecode_ai	= range_codes_pci1710_3,
+		.rangelist_ao	= NULL,
+		.ai_ns_min	= 10000,
+		.fifo_half_size	= 2048,
+	}, {
+		.name		= "pci1720",
+		.device_id	= 0x1720,
+		.iorange	= IORANGE_1720,
+		.have_irq	= 0,
+		.cardtype	= TYPE_PCI1720,
+		.n_aichan	= 0,
+		.n_aichand	= 0,
+		.n_aochan	= 4,
+		.n_dichan	= 0,
+		.n_dochan	= 0,
+		.n_counter	= 0,
+		.ai_maxdata	= 0x0000,
+		.ao_maxdata	= 0x0fff,
+		.rangelist_ai	= NULL,
+		.rangecode_ai	= NULL,
+		.rangelist_ao	= &range_pci1720,
+		.ai_ns_min	= 0,
+		.fifo_half_size	= 0,
+	}, {
+		.name		= "pci1731",
+		.device_id	= 0x1731,
+		.iorange	= IORANGE_171x,
+		.have_irq	= 1,
+		.cardtype	= TYPE_PCI171X,
+		.n_aichan	= 16,
+		.n_aichand	= 0,
+		.n_aochan	= 0,
+		.n_dichan	= 16,
+		.n_dochan	= 16,
+		.n_counter	= 0,
+		.ai_maxdata	= 0x0fff,
+		.ao_maxdata	= 0x0000,
+		.rangelist_ai	= &range_pci17x1,
+		.rangecode_ai	= range_codes_pci17x1,
+		.rangelist_ao	= NULL,
+		.ai_ns_min	= 10000,
+		.fifo_half_size	= 512,
+	}, {
+		/* dummy entry corresponding to driver name */
+		.name		= DRV_NAME,
+	},
 };
 
 struct pci1710_private {
-- 
1.7.11

