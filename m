Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031856Ab2CIUBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:01:18 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52559 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031820Ab2CITxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:53:36 -0500
Message-Id: <20120309190218.815744867@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:03:02 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [ 48/68] OMAP: 4430SDP/Panda: rename HPD GPIO to CT_CP_HPD
In-Reply-To: <20120309194409.GA2069@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ti.com>

commit 3932a32fcf5393f8be70ac99dc718ad7ad0a415b upstream.

The GPIO 60 on 4430sdp and Panda is not HPD GPIO, as currently marked in
the board files, but CT_CP_HPD, which is used to enable/disable HPD
functionality.

This patch renames the GPIO.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/board-4430sdp.c    |    4 ++--
 arch/arm/mach-omap2/board-omap4panda.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@ -49,7 +49,7 @@
 #define ETH_KS8851_QUART		138
 #define OMAP4_SFH7741_SENSOR_OUTPUT_GPIO	184
 #define OMAP4_SFH7741_ENABLE_GPIO		188
-#define HDMI_GPIO_HPD 60 /* Hot plug pin for HDMI */
+#define HDMI_GPIO_CT_CP_HPD 60 /* HPD mode enable/disable */
 #define HDMI_GPIO_LS_OE 41 /* Level shifter for HDMI */
 
 static const int sdp4430_keymap[] = {
@@ -591,7 +591,7 @@ static void sdp4430_hdmi_mux_init(void)
 }
 
 static struct gpio sdp4430_hdmi_gpios[] = {
-	{ HDMI_GPIO_HPD,	GPIOF_OUT_INIT_HIGH,	"hdmi_gpio_hpd"   },
+	{ HDMI_GPIO_CT_CP_HPD, GPIOF_OUT_INIT_HIGH, "hdmi_gpio_ct_cp_hpd" },
 	{ HDMI_GPIO_LS_OE,	GPIOF_OUT_INIT_HIGH,	"hdmi_gpio_ls_oe" },
 };
 
--- a/arch/arm/mach-omap2/board-omap4panda.c
+++ b/arch/arm/mach-omap2/board-omap4panda.c
@@ -52,7 +52,7 @@
 #define GPIO_HUB_NRESET		62
 #define GPIO_WIFI_PMENA		43
 #define GPIO_WIFI_IRQ		53
-#define HDMI_GPIO_HPD 60 /* Hot plug pin for HDMI */
+#define HDMI_GPIO_CT_CP_HPD 60 /* HPD mode enable/disable */
 #define HDMI_GPIO_LS_OE 41 /* Level shifter for HDMI */
 
 /* wl127x BT, FM, GPS connectivity chip */
@@ -627,7 +627,7 @@ static void omap4_panda_hdmi_mux_init(vo
 }
 
 static struct gpio panda_hdmi_gpios[] = {
-	{ HDMI_GPIO_HPD,	GPIOF_OUT_INIT_HIGH, "hdmi_gpio_hpd"   },
+	{ HDMI_GPIO_CT_CP_HPD, GPIOF_OUT_INIT_HIGH, "hdmi_gpio_ct_cp_hpd" },
 	{ HDMI_GPIO_LS_OE,	GPIOF_OUT_INIT_HIGH, "hdmi_gpio_ls_oe" },
 };
 


