Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031972Ab2CIT50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:57:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64616 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031955Ab2CITya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:54:30 -0500
Message-Id: <20120309190207.102432133@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:03:01 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [ 59/95] OMAP: 4430SDP/Panda: use gpio_free_array to free HDMI gpios
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ti.com>

commit 575753e3bea3b67eef8e454fb87f719e3f7da599 upstream.

Instead of freeing the GPIOs individually, use gpio_free_array().

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/board-4430sdp.c    |    3 +--
 arch/arm/mach-omap2/board-omap4panda.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@ -628,8 +628,7 @@ static int sdp4430_panel_enable_hdmi(str
 
 static void sdp4430_panel_disable_hdmi(struct omap_dss_device *dssdev)
 {
-	gpio_free(HDMI_GPIO_LS_OE);
-	gpio_free(HDMI_GPIO_HPD);
+	gpio_free_array(sdp4430_hdmi_gpios, ARRAY_SIZE(sdp4430_hdmi_gpios));
 }
 
 static struct nokia_dsi_panel_data dsi1_panel = {
--- a/arch/arm/mach-omap2/board-omap4panda.c
+++ b/arch/arm/mach-omap2/board-omap4panda.c
@@ -512,8 +512,7 @@ static int omap4_panda_panel_enable_hdmi
 
 static void omap4_panda_panel_disable_hdmi(struct omap_dss_device *dssdev)
 {
-	gpio_free(HDMI_GPIO_LS_OE);
-	gpio_free(HDMI_GPIO_HPD);
+	gpio_free_array(panda_hdmi_gpios, ARRAY_SIZE(panda_hdmi_gpios));
 }
 
 static struct omap_dss_device  omap4_panda_hdmi_device = {


