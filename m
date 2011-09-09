Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291Ab1IIO4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 10:56:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46912 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759256Ab1IIO4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 10:56:22 -0400
From: Keshava Munegowda <keshava_mgowda@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Keshava Munegowda <keshava_mgowda@ti.com>, <balbi@ti.com>,
        <gadiyar@ti.com>, <sameo@linux.intel.com>, <parthab@india.ti.com>,
        <tony@atomide.com>, <khilman@ti.com>, <b-cousson@ti.com>,
        <paul@pwsan.com>, <johnstul@us.ibm.com>, <vishwanath.bs@ti.com>,
        Keshava Munegowda <Keshava_mgowda@ti.com>
Subject: [PATCH 2/2] arm: omap: usb: enable I/O wakeups of ehci and ohci hwmods of omap3
Date: Fri, 9 Sep 2011 20:22:47 +0530
Message-ID: <1315579967-24945-3-git-send-email-keshava_mgowda@ti.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1315579967-24945-2-git-send-email-keshava_mgowda@ti.com>
References: <1315579967-24945-1-git-send-email-keshava_mgowda@ti.com>
 <1315579967-24945-2-git-send-email-keshava_mgowda@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keshava Munegowda <Keshava_mgowda@ti.com>

For ehci and ohci hwmods, the omap3 I/O wakeup capablity is enabled.
for ehci in phy mode,
	- the DAT0 and DIR I/O pad is set as wakeup capable
for ohci in serial mode
	- usbb*_mm_rxdp is set as I/O wakeup for 6 pin serial mode
	- usbb*_mm_rxrcv is set as I/O wakeup for 4 pin serial mode
	- usbb*_mm_txen is set as I/O wakeup for 3 pin serial mode
	- usbb*_mm_txdat is set as I/O wakeup for 2 pin serial mode

Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
---
 arch/arm/mach-omap2/usb-host.c |   96 +++++++++++++++++++++++++++++++++-------
 1 files changed, 80 insertions(+), 16 deletions(-)

diff --git a/arch/arm/mach-omap2/usb-host.c b/arch/arm/mach-omap2/usb-host.c
index cf2e726..d3cb100 100644
--- a/arch/arm/mach-omap2/usb-host.c
+++ b/arch/arm/mach-omap2/usb-host.c
@@ -467,7 +467,11 @@ static struct omap_device_pad omap3_port1_phy_pads[] __initdata = {
 	},
 	{
 		.name = "etk_d8.hsusb1_dir",
-		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3,
+		.enable = (OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3) &
+						~OMAP_WAKEUP_EN,
+		.flags  = OMAP_DEVICE_PAD_REMUX | OMAP_DEVICE_PAD_WAKEUP,
+		.idle = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3 |
+						OMAP_WAKEUP_EN,
 	},
 	{
 		.name = "etk_d9.hsusb1_nxt",
@@ -475,7 +479,11 @@ static struct omap_device_pad omap3_port1_phy_pads[] __initdata = {
 	},
 	{
 		.name = "etk_d0.hsusb1_data0",
-		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3,
+		.enable = (OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3) &
+						~OMAP_WAKEUP_EN,
+		.flags  = OMAP_DEVICE_PAD_REMUX | OMAP_DEVICE_PAD_WAKEUP,
+		.idle = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3 |
+						OMAP_WAKEUP_EN,
 	},
 	{
 		.name = "etk_d1.hsusb1_data1",
@@ -569,7 +577,11 @@ static struct omap_device_pad omap3_port2_phy_pads[] __initdata = {
 	},
 	{
 		.name = "etk_d12.hsusb2_dir",
-		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3,
+		.enable = (OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3) &
+						~OMAP_WAKEUP_EN,
+		.flags  = OMAP_DEVICE_PAD_REMUX | OMAP_DEVICE_PAD_WAKEUP,
+		.idle = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3 |
+						OMAP_WAKEUP_EN,
 	},
 	{
 		.name = "etk_d13.hsusb2_nxt",
@@ -577,7 +589,11 @@ static struct omap_device_pad omap3_port2_phy_pads[] __initdata = {
 	},
 	{
 		.name = "etk_d14.hsusb2_data0",
-		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3,
+		.enable = (OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3) &
+						~OMAP_WAKEUP_EN,
+		.flags  = OMAP_DEVICE_PAD_REMUX | OMAP_DEVICE_PAD_WAKEUP,
+		.idle = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE3 |
+						OMAP_WAKEUP_EN,
 	},
 	{
 		.name = "etk_d15.hsusb2_data1",
@@ -714,7 +730,11 @@ static struct omap_device_pad omap3_port3_tll_pads[] __initdata = {
 static struct omap_device_pad omap3_port1_6pin_pads[] __initdata = {
 	{
 		.name = "etk_clk.mm1_rxdp",
-		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+		.enable = (OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5) &
+						~OMAP_WAKEUP_EN,
+		.flags  = OMAP_DEVICE_PAD_REMUX | OMAP_DEVICE_PAD_WAKEUP,
+		.idle = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5 |
+						OMAP_WAKEUP_EN,
 	},
 	{
 		.name = "etk_d9.mm1_rxdm",
@@ -741,7 +761,11 @@ static struct omap_device_pad omap3_port1_6pin_pads[] __initdata = {
 static struct omap_device_pad omap3_port1_4pin_pads[] __initdata = {
 	{
 		.name = "etk_d0.mm1_rxrcv",
-		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+		.enable = (OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5) &
+						~OMAP_WAKEUP_EN,
+		.flags  = OMAP_DEVICE_PAD_REMUX | OMAP_DEVICE_PAD_WAKEUP,
+		.idle = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5 |
+						OMAP_WAKEUP_EN,
 	},
 	{
 		.name = "etk_d7.mm1_txen_n",
@@ -760,7 +784,11 @@ static struct omap_device_pad omap3_port1_4pin_pads[] __initdata = {
 static struct omap_device_pad omap3_port1_3pin_pads[] __initdata = {
 	{
 		.name = "etk_d7.mm1_txen_n",
-		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+		.enable = (OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5) &
+						~OMAP_WAKEUP_EN,
+		.flags  = OMAP_DEVICE_PAD_REMUX | OMAP_DEVICE_PAD_WAKEUP,
+		.idle = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5 |
+						OMAP_WAKEUP_EN,
 	},
 	{
 		.name = "etk_d2.mm1_txdat",
@@ -775,7 +803,11 @@ static struct omap_device_pad omap3_port1_3pin_pads[] __initdata = {
 static struct omap_device_pad omap3_port1_2pin_pads[] __initdata = {
 	{
 		.name = "etk_d2.mm1_txdat",
-		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+		.enable = (OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5) &
+						~OMAP_WAKEUP_EN,
+		.flags  = OMAP_DEVICE_PAD_REMUX | OMAP_DEVICE_PAD_WAKEUP,
+		.idle = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5 |
+						OMAP_WAKEUP_EN,
 	},
 	{
 		.name = "etk_d1.mm1_txse0",
@@ -786,7 +818,11 @@ static struct omap_device_pad omap3_port1_2pin_pads[] __initdata = {
 static struct omap_device_pad omap3_port2_6pin_pads[] __initdata = {
 	{
 		.name = "etk_d11.mm2_rxdp",
-		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+		.enable = (OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5) &
+						~OMAP_WAKEUP_EN,
+		.flags  = OMAP_DEVICE_PAD_REMUX | OMAP_DEVICE_PAD_WAKEUP,
+		.idle = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5 |
+						OMAP_WAKEUP_EN,
 	},
 	{
 		.name = "etk_d13.mm2_rxdm",
@@ -813,7 +849,11 @@ static struct omap_device_pad omap3_port2_6pin_pads[] __initdata = {
 static struct omap_device_pad omap3_port2_4pin_pads[] __initdata = {
 	{
 		.name = "etk_d14.mm2_rxrcv",
-		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+		.enable = (OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5) &
+						~OMAP_WAKEUP_EN,
+		.flags  = OMAP_DEVICE_PAD_REMUX | OMAP_DEVICE_PAD_WAKEUP,
+		.idle = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5 |
+						OMAP_WAKEUP_EN,
 	},
 	{
 		.name = "mcspi2_cs1.mm2_txen_n",
@@ -832,7 +872,11 @@ static struct omap_device_pad omap3_port2_4pin_pads[] __initdata = {
 static struct omap_device_pad omap3_port2_3pin_pads[] __initdata = {
 	{
 		.name = "mcspi2_cs1.mm2_txen_n",
-		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+		.enable = (OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5) &
+						~OMAP_WAKEUP_EN,
+		.flags  = OMAP_DEVICE_PAD_REMUX | OMAP_DEVICE_PAD_WAKEUP,
+		.idle = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5 |
+						OMAP_WAKEUP_EN,
 	},
 	{
 		.name = "etk_d15.mm2_txse0",
@@ -847,7 +891,11 @@ static struct omap_device_pad omap3_port2_3pin_pads[] __initdata = {
 static struct omap_device_pad omap3_port2_2pin_pads[] __initdata = {
 	{
 		.name = "etk_d15.mm2_txse0",
-		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+		.enable = (OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5) &
+						~OMAP_WAKEUP_EN,
+		.flags  = OMAP_DEVICE_PAD_REMUX | OMAP_DEVICE_PAD_WAKEUP,
+		.idle = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5 |
+						OMAP_WAKEUP_EN,
 	},
 	{
 		.name = "mcspi1_cs3.mm2_txdat",
@@ -858,7 +906,11 @@ static struct omap_device_pad omap3_port2_2pin_pads[] __initdata = {
 static struct omap_device_pad omap3_port3_6pin_pads[] __initdata = {
 	{
 		.name = "sdmmc2_dat5.mm3_rxdp",
-		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+		.enable = (OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6) &
+						~OMAP_WAKEUP_EN,
+		.flags  = OMAP_DEVICE_PAD_REMUX | OMAP_DEVICE_PAD_WAKEUP,
+		.idle = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6 |
+						OMAP_WAKEUP_EN,
 	},
 	{
 		.name = "sdmmc2_dat7.mm3_rxdm",
@@ -885,7 +937,11 @@ static struct omap_device_pad omap3_port3_6pin_pads[] __initdata = {
 static struct omap_device_pad omap3_port3_4pin_pads[] __initdata = {
 	{
 		.name = "mcbsp4_dr.mm3_rxrcv",
-		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+		.enable = (OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6) &
+						~OMAP_WAKEUP_EN,
+		.flags  = OMAP_DEVICE_PAD_REMUX | OMAP_DEVICE_PAD_WAKEUP,
+		.idle = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6 |
+						OMAP_WAKEUP_EN,
 	},
 	{
 		.name = "mcbsp4_fsx.mm3_txen_n",
@@ -904,7 +960,11 @@ static struct omap_device_pad omap3_port3_4pin_pads[] __initdata = {
 static struct omap_device_pad omap3_port3_3pin_pads[] __initdata = {
 	{
 		.name = "mcbsp4_fsx.mm3_txen_n",
-		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+		.enable = (OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6) &
+						~OMAP_WAKEUP_EN,
+		.flags  = OMAP_DEVICE_PAD_REMUX | OMAP_DEVICE_PAD_WAKEUP,
+		.idle = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6 |
+						OMAP_WAKEUP_EN,
 	},
 	{
 		.name = "mcbsp4_clkx.mm3_txse0",
@@ -919,7 +979,11 @@ static struct omap_device_pad omap3_port3_3pin_pads[] __initdata = {
 static struct omap_device_pad omap3_port3_2pin_pads[] __initdata = {
 	{
 		.name = "mcbsp4_clkx.mm3_txse0",
-		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6,
+		.enable = (OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6) &
+						~OMAP_WAKEUP_EN,
+		.flags  = OMAP_DEVICE_PAD_REMUX | OMAP_DEVICE_PAD_WAKEUP,
+		.idle = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE6 |
+						OMAP_WAKEUP_EN,
 	},
 	{
 		.name = "mcbsp4_dx.mm3_txdat",
-- 
1.6.0.4

