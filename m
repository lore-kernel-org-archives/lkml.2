Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423711Ab2LGBAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 20:00:40 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:43888 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423693Ab2LGBAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 20:00:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [ 25/27] drm/i915: Add no-lvds quirk for Supermicro X7SPA-H
Date: Thu,  6 Dec 2012 16:59:09 -0800
Message-Id: <20121207005833.301622554@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121207005825.232489605@linuxfoundation.org>
References: <20121207005825.232489605@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit c31407a3672aaebb4acddf90944a114fa5c8af7b upstream.

Reported-and-tested-by: Francois Tigeot <ftigeot@wolfpond.org>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=55375
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_lvds.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -796,6 +796,14 @@ static const struct dmi_system_id intel_
 			DMI_MATCH(DMI_BOARD_NAME, "D525TUD"),
 		},
 	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
+		.ident = "Supermicro X7SPA-H",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Supermicro"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "X7SPA-H"),
+		},
+	},
 
 	{ }	/* terminating entry */
 };


