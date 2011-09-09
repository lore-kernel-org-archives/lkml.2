Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248Ab1IIO4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 10:56:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46906 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759123Ab1IIO4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 10:56:20 -0400
From: Keshava Munegowda <keshava_mgowda@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Keshava Munegowda <keshava_mgowda@ti.com>, <balbi@ti.com>,
        <gadiyar@ti.com>, <sameo@linux.intel.com>, <parthab@india.ti.com>,
        <tony@atomide.com>, <khilman@ti.com>, <b-cousson@ti.com>,
        <paul@pwsan.com>, <johnstul@us.ibm.com>, <vishwanath.bs@ti.com>,
        Kishon Vijay Abraham <kishon@ti.com>
Subject: [PATCH 1/2] arm: omap: usb: enable I/O wakeups of ehci and ohci hwmods of omap4
Date: Fri, 9 Sep 2011 20:22:46 +0530
Message-ID: <1315579967-24945-2-git-send-email-keshava_mgowda@ti.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1315579967-24945-1-git-send-email-keshava_mgowda@ti.com>
References: <1315579967-24945-1-git-send-email-keshava_mgowda@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kishon Vijay Abraham <kishon@ti.com>

For ehci and ohci hwmods, the omap4 I/O wakeup capablity is enabled.
for ehci in phy mode,
	- the DAT0 and DIR I/O pad is set as wakeup capable
for ohci in serial mode
	- usbb*_mm_rxdp is set as I/O wakeup for 6 pin serial mode
	- usbb*_mm_rxrcv is set as I/O wakeup for 4 pin serial mode
	- usbb*_mm_txen is set as I/O wakeup for 3 pin serial mode
	- usbb*_mm_txdat is set as I/O wakeup for 2 pin serial mode

Signed-off-by: Kishon Vijay Abraham <kishon@ti.com>
Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
---
 arch/arm/mach-omap2/usb-host.c |   76 +++++++++++++++++++++++++++++++++------
 1 files changed, 64 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-omap2/usb-host.c b/arch/arm/mach-omap2/usb-host.c
index 485341f..cf2e726 100644
--- a/arch/arm/mach-omap2/usb-host.c
+++ b/arch/arm/mach-omap2/usb-host.c
@@ -64,7 +64,12 @@ static struct omap_device_pad port1_phy_pads[] __initdata = {
 	},
 	{
 		.name = "usbb1_ulpitll_dir.usbb1_ulpiphy_dir",
-		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+		.enable = (OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4) &
+						~OMAP_WAKEUP_EN,
+		.flags  = OMAP_DEVICE_PAD_REMUX | OMAP_DEVICE_PAD_WAKEUP,
+		.idle = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4 |
+						OMAP_WAKEUP_EN,
+
 	},
 	{
 		.name = "usbb1_ulpitll_nxt.usbb1_ulpiphy_nxt",
@@ -72,7 +77,12 @@ static struct omap_device_pad port1_phy_pads[] __initdata = {
 	},
 	{
 		.name = "usbb1_ulpitll_dat0.usbb1_ulpiphy_dat0",
-		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+		.enable = (OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4) &
+						~OMAP_WAKEUP_EN,
+		.flags  = OMAP_DEVICE_PAD_REMUX | OMAP_DEVICE_PAD_WAKEUP,
+		.idle = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4 |
+						OMAP_WAKEUP_EN,
+
 	},
 	{
 		.name = "usbb1_ulpitll_dat1.usbb1_ulpiphy_dat1",
@@ -166,7 +176,11 @@ static struct omap_device_pad port2_phy_pads[] __initdata = {
 	},
 	{
 		.name = "usbb2_ulpitll_dir.usbb2_ulpiphy_dir",
-		.enable	= OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+		.enable = (OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4) &
+						~OMAP_WAKEUP_EN,
+		.flags  = OMAP_DEVICE_PAD_REMUX | OMAP_DEVICE_PAD_WAKEUP,
+		.idle = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4 |
+						OMAP_WAKEUP_EN,
 	},
 	{
 		.name = "usbb2_ulpitll_nxt.usbb2_ulpiphy_nxt",
@@ -174,7 +188,12 @@ static struct omap_device_pad port2_phy_pads[] __initdata = {
 	},
 	{
 		.name = "usbb2_ulpitll_dat0.usbb2_ulpiphy_dat0",
-		.enable	= OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+		.enable = (OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4) &
+						~OMAP_WAKEUP_EN,
+		.flags  = OMAP_DEVICE_PAD_REMUX | OMAP_DEVICE_PAD_WAKEUP,
+		.idle = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4 |
+						OMAP_WAKEUP_EN,
+
 	},
 	{
 		.name = "usbb2_ulpitll_dat1.usbb2_ulpiphy_dat1",
@@ -260,7 +279,11 @@ static struct omap_device_pad port2_tll_pads[] __initdata = {
 static struct omap_device_pad port1_6pin_pads[] __initdata = {
 	{
 		.name = "usbb1_ulpitll_stp.usbb1_mm_rxdp",
-		.enable	= OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+		.enable = (OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5) &
+						~OMAP_WAKEUP_EN,
+		.flags  = OMAP_DEVICE_PAD_REMUX | OMAP_DEVICE_PAD_WAKEUP,
+		.idle	= OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5 |
+						OMAP_WAKEUP_EN,
 	},
 	{
 		.name = "usbb1_ulpitll_nxt.usbb1_mm_rxdm",
@@ -287,7 +310,11 @@ static struct omap_device_pad port1_6pin_pads[] __initdata = {
 static struct omap_device_pad port1_4pin_pads[] __initdata = {
 	{
 		.name = "usbb1_ulpitll_dat0.usbb1_mm_rxrcv",
-		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+		.enable = (OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5) &
+						~OMAP_WAKEUP_EN,
+		.flags  = OMAP_DEVICE_PAD_REMUX | OMAP_DEVICE_PAD_WAKEUP,
+		.idle	= OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5 |
+						OMAP_WAKEUP_EN,
 	},
 	{
 		.name = "usbb1_ulpitll_dat3.usbb1_mm_txen",
@@ -306,7 +333,12 @@ static struct omap_device_pad port1_4pin_pads[] __initdata = {
 static struct omap_device_pad port1_3pin_pads[] __initdata = {
 	{
 		.name = "usbb1_ulpitll_dat3.usbb1_mm_txen",
-		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+		.enable = (OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5) &
+						~OMAP_WAKEUP_EN,
+		.flags  = OMAP_DEVICE_PAD_REMUX | OMAP_DEVICE_PAD_WAKEUP,
+		.idle	= OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5 |
+						OMAP_WAKEUP_EN,
+
 	},
 	{
 		.name = "usbb1_ulpitll_dat1.usbb1_mm_txdat",
@@ -321,7 +353,11 @@ static struct omap_device_pad port1_3pin_pads[] __initdata = {
 static struct omap_device_pad port1_2pin_pads[] __initdata = {
 	{
 		.name = "usbb1_ulpitll_dat1.usbb1_mm_txdat",
-		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+		.enable = (OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5) &
+						~OMAP_WAKEUP_EN,
+		.flags  = OMAP_DEVICE_PAD_REMUX | OMAP_DEVICE_PAD_WAKEUP,
+		.idle	= OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5 |
+						OMAP_WAKEUP_EN,
 	},
 	{
 		.name = "usbb1_ulpitll_dat2.usbb1_mm_txse0",
@@ -332,7 +368,11 @@ static struct omap_device_pad port1_2pin_pads[] __initdata = {
 static struct omap_device_pad port2_6pin_pads[] __initdata = {
 	{
 		.name = "abe_mcbsp2_dr.usbb2_mm_rxdp",
-		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+		.enable = (OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4) &
+						~OMAP_WAKEUP_EN,
+		.flags  = OMAP_DEVICE_PAD_REMUX | OMAP_DEVICE_PAD_WAKEUP,
+		.idle	= OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4 |
+						OMAP_WAKEUP_EN,
 	},
 	{
 		.name = "abe_mcbsp2_clkx.usbb2_mm_rxdm",
@@ -359,7 +399,11 @@ static struct omap_device_pad port2_6pin_pads[] __initdata = {
 static struct omap_device_pad port2_4pin_pads[] __initdata = {
 	{
 		.name = "abe_mcbsp2_dx.usbb2_mm_rxrcv",
-		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+		.enable = (OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4) &
+						~OMAP_WAKEUP_EN,
+		.flags  = OMAP_DEVICE_PAD_REMUX | OMAP_DEVICE_PAD_WAKEUP,
+		.idle	= OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4 |
+						OMAP_WAKEUP_EN,
 	},
 	{
 		.name = "abe_mcbsp2_fsx.usbb2_mm_txen",
@@ -378,7 +422,11 @@ static struct omap_device_pad port2_4pin_pads[] __initdata = {
 static struct omap_device_pad port2_3pin_pads[] __initdata = {
 	{
 		.name = "abe_mcbsp2_fsx.usbb2_mm_txen",
-		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+		.enable = (OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4) &
+						~OMAP_WAKEUP_EN,
+		.flags  = OMAP_DEVICE_PAD_REMUX | OMAP_DEVICE_PAD_WAKEUP,
+		.idle	= OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4 |
+						OMAP_WAKEUP_EN,
 	},
 	{
 		.name = "abe_dmic_din1.usbb2_mm_txdat",
@@ -393,7 +441,11 @@ static struct omap_device_pad port2_3pin_pads[] __initdata = {
 static struct omap_device_pad port2_2pin_pads[] __initdata = {
 	{
 		.name = "abe_dmic_din1.usbb2_mm_txdat",
-		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+		.enable = (OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4) &
+						~OMAP_WAKEUP_EN,
+		.flags  = OMAP_DEVICE_PAD_REMUX | OMAP_DEVICE_PAD_WAKEUP,
+		.idle	= OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4 |
+						OMAP_WAKEUP_EN,
 	},
 	{
 		.name = "abe_dmic_clk1.usbb2_mm_txse0",
-- 
1.6.0.4

