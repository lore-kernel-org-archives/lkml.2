Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab1G0WBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:01:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:50745 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755620Ab1G0Vsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="32826369"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: hdegoede@redhat.com, keithp@keithp.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [43/99] drm/i915: Add a no lvds quirk for the Asus EeeBox PC EB1007
Message-Id: <20110727214842.19BF62403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Hans de Goede <hdegoede@redhat.com>

commit 6a574b5b9b186e28abd3e571dfd1700c5220b510 upstream.

I found this while figuring out why gnome-shell would not run on my
Asus EeeBox PC EB1007. As a standalone "pc" this device cleary does not have
an internal panel, yet it claims it does. Add a quirk to fix this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/gpu/drm/i915/intel_lvds.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6.35.y/drivers/gpu/drm/i915/intel_lvds.c
===================================================================
--- linux-2.6.35.y.orig/drivers/gpu/drm/i915/intel_lvds.c
+++ linux-2.6.35.y/drivers/gpu/drm/i915/intel_lvds.c
@@ -832,6 +832,14 @@ static const struct dmi_system_id intel_
 			DMI_MATCH(DMI_PRODUCT_NAME, "U800"),
 		},
 	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
+		.ident = "Asus EeeBox PC EB1007",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "EB1007"),
+		},
+	},
 
 	{ }	/* terminating entry */
 };
