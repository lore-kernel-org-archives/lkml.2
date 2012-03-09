Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030973Ab2CITtG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:49:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48917 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030906Ab2CITtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:49:01 -0500
Message-Id: <20120309190207.423374647@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:03:05 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [ 63/95] OMAP: 4430SDP/Panda: add HDMI HPD gpio
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ti.com>

commit aa74274b464d4aa24703963ac89a0ee942d5d267 upstream.

Both Panda and 4430SDP use GPIO 63 as HDMI hot-plug-detect. Configure
this GPIO in the board files.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/board-4430sdp.c    |    3 +++
 arch/arm/mach-omap2/board-omap4panda.c |    3 +++
 2 files changed, 6 insertions(+)

--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@ -54,6 +54,7 @@
 #define OMAP4_SFH7741_ENABLE_GPIO		188
 #define HDMI_GPIO_CT_CP_HPD 60 /* HPD mode enable/disable */
 #define HDMI_GPIO_LS_OE 41 /* Level shifter for HDMI */
+#define HDMI_GPIO_HPD  63 /* Hotplug detect */
 #define DISPLAY_SEL_GPIO	59	/* LCD2/PicoDLP switch */
 #define DLP_POWER_ON_GPIO	40
 
@@ -608,6 +609,7 @@ static void sdp4430_hdmi_mux_init(void)
 static struct gpio sdp4430_hdmi_gpios[] = {
 	{ HDMI_GPIO_CT_CP_HPD, GPIOF_OUT_INIT_HIGH, "hdmi_gpio_ct_cp_hpd" },
 	{ HDMI_GPIO_LS_OE,	GPIOF_OUT_INIT_HIGH,	"hdmi_gpio_ls_oe" },
+	{ HDMI_GPIO_HPD, GPIOF_DIR_IN, "hdmi_gpio_hpd" },
 };
 
 static int sdp4430_panel_enable_hdmi(struct omap_dss_device *dssdev)
@@ -827,6 +829,7 @@ static void omap_4430sdp_display_init(vo
 
 	omap_mux_init_gpio(HDMI_GPIO_LS_OE, OMAP_PIN_OUTPUT);
 	omap_mux_init_gpio(HDMI_GPIO_CT_CP_HPD, OMAP_PIN_OUTPUT);
+	omap_mux_init_gpio(HDMI_GPIO_HPD, OMAP_PIN_INPUT_PULLDOWN);
 }
 
 #ifdef CONFIG_OMAP_MUX
--- a/arch/arm/mach-omap2/board-omap4panda.c
+++ b/arch/arm/mach-omap2/board-omap4panda.c
@@ -53,6 +53,7 @@
 #define GPIO_WIFI_IRQ		53
 #define HDMI_GPIO_CT_CP_HPD 60 /* HPD mode enable/disable */
 #define HDMI_GPIO_LS_OE 41 /* Level shifter for HDMI */
+#define HDMI_GPIO_HPD  63 /* Hotplug detect */
 
 /* wl127x BT, FM, GPS connectivity chip */
 static int wl1271_gpios[] = {46, -1, -1};
@@ -492,6 +493,7 @@ static void omap4_panda_hdmi_mux_init(vo
 static struct gpio panda_hdmi_gpios[] = {
 	{ HDMI_GPIO_CT_CP_HPD, GPIOF_OUT_INIT_HIGH, "hdmi_gpio_ct_cp_hpd" },
 	{ HDMI_GPIO_LS_OE,	GPIOF_OUT_INIT_HIGH, "hdmi_gpio_ls_oe" },
+	{ HDMI_GPIO_HPD, GPIOF_DIR_IN, "hdmi_gpio_hpd" },
 };
 
 static int omap4_panda_panel_enable_hdmi(struct omap_dss_device *dssdev)
@@ -544,6 +546,7 @@ void omap4_panda_display_init(void)
 
 	omap_mux_init_gpio(HDMI_GPIO_LS_OE, OMAP_PIN_OUTPUT);
 	omap_mux_init_gpio(HDMI_GPIO_CT_CP_HPD, OMAP_PIN_OUTPUT);
+	omap_mux_init_gpio(HDMI_GPIO_HPD, OMAP_PIN_INPUT_PULLDOWN);
 }
 
 static void __init omap4_panda_init(void)


