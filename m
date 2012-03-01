Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965769Ab2CAVvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:51:14 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40975 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965618Ab2CAVvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:51:07 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.136.231 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120301213922.418552074@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Thu, 01 Mar 2012 13:39:23 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Keith Packard <keithp@keithp.com>
Subject: [ 01/34] drm/i915: no lvds quirk for AOpen MP45
In-Reply-To: <20120301214654.GA13231@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit e57b6886f555ab57f40a01713304e2053efe51ec upstream.

According to a bug report, it doesn't have one.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=44263
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_lvds.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -892,6 +892,14 @@ static const struct dmi_system_id intel_
 	},
 	{
 		.callback = intel_no_lvds_dmi_callback,
+                .ident = "AOpen i45GMx-I",
+                .matches = {
+                        DMI_MATCH(DMI_BOARD_VENDOR, "AOpen"),
+                        DMI_MATCH(DMI_BOARD_NAME, "i45GMx-I"),
+                },
+        },
+	{
+		.callback = intel_no_lvds_dmi_callback,
 		.ident = "Aopen i945GTt-VFA",
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_VERSION, "AO00001JW"),


