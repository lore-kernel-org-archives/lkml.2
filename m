Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030564Ab2COO7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:59:09 -0400
Received: from HSI-KBW-109-192-167-159.hsi6.kabel-badenwuerttemberg.de ([109.192.167.159]:38398
	"EHLO rack0slot8.osadl.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932396Ab2COO7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:59:01 -0400
Message-Id: <20120315145829.555961411@osadl.org>
User-Agent: quilt/0.48-1
Date: Thu, 15 Mar 2012 15:56:27 +0100
From: Carsten Emde <C.Emde@osadl.org>
To: David Airlie <airlied@linux.ie>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Keith Packard <keithp@keithp.com>,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Carsten Emde <C.Emde@osadl.org>, DRI <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [V5 PATCH 4/4] drivers-gpu-drm-i915-panel-invert-brightness-acer-aspire-5734z.patch
References: <20120315145623.486070468@osadl.org>
Content-Disposition: inline; filename=drivers-gpu-drm-i915-panel-invert-brightness-acer-aspire-5734z.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark the Acer Aspire 5734Z that this machines requires the module to
invert the panel backlight brightness value after reading from and prior
to writing to the PCI configuration space.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>

---
 drivers/gpu/drm/i915/intel_display.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-3.3-rc7/drivers/gpu/drm/i915/intel_display.c
===================================================================
--- linux-3.3-rc7.orig/drivers/gpu/drm/i915/intel_display.c
+++ linux-3.3-rc7/drivers/gpu/drm/i915/intel_display.c
@@ -8951,7 +8951,8 @@ static void quirk_ssc_force_disable(stru
 }
 
 /*
- * A machine may need to invert the panel backlight brightness value
+ * A machine (e.g. Acer Aspire 5734Z) may need to invert the panel backlight
+ * brightness value
  */
 static void quirk_invert_brightness(struct drm_device *dev)
 {
@@ -8993,6 +8994,9 @@ struct intel_quirk intel_quirks[] = {
 
 	/* Sony Vaio Y cannot use SSC on LVDS */
 	{ 0x0046, 0x104d, 0x9076, quirk_ssc_force_disable },
+
+	/* Acer Aspire 5734Z must invert backlight brightness */
+	{ 0x2a42, 0x1025, 0x0459, quirk_invert_brightness },
 };
 
 static void intel_init_quirks(struct drm_device *dev)

