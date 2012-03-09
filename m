Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030994Ab2CITtM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:49:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53292 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030906Ab2CITtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:49:08 -0500
Message-Id: <20120309190207.584557057@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:03:07 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Rob Clark <rob@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [ 65/95] OMAPDSS: HDMI: hot plug detect fix
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <rob@ti.com>

commit ca888a7958b3d808e4efd08ceff88913f4212c69 upstream.

The "OMAPDSS: HDMI: PHY burnout fix" commit switched the HDMI driver
over to using a GPIO for plug detect.  Unfortunately the ->detect()
method was not also updated, causing HDMI to no longer work for the
omapdrm driver (because it would actually check if a connection was
detected before attempting to enable display).

Signed-off-by: Rob Clark <rob@ti.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c
+++ b/drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c
@@ -479,14 +479,7 @@ int ti_hdmi_4xxx_read_edid(struct hdmi_i
 
 bool ti_hdmi_4xxx_detect(struct hdmi_ip_data *ip_data)
 {
-	int r;
-
-	void __iomem *base = hdmi_core_sys_base(ip_data);
-
-	/* HPD */
-	r = REG_GET(base, HDMI_CORE_SYS_SYS_STAT, 1, 1);
-
-	return r == 1;
+	return gpio_get_value(ip_data->hpd_gpio);
 }
 
 static void hdmi_core_init(struct hdmi_core_video_config *video_cfg,


