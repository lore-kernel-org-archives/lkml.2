Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072Ab2BQBDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 20:03:50 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:35265 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756890Ab2BQBAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 20:00:18 -0500
X-Sasl-enc: 6hHWBEawEZbQ9SYEkj20/xTW+/5TNXXZY7CKPuoG5iaZ 1329440417
X-Mailbox-Line: From gregkh@linuxfoundation.org Thu Feb 16 16:55:34 2012
Message-Id: <20120217005534.831735174@linuxfoundation.org>
User-Agent: quilt/0.51-15.1
Date: Thu, 16 Feb 2012 16:55:40 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Keith Packard <keithp@keithp.com>
Subject: [06/28] drm/i915: no lvds quirk for AOpen MP45
In-Reply-To: <20120217005609.GA17081@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -694,6 +694,14 @@ static const struct dmi_system_id intel_
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


