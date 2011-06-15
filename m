Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab1FPHgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:36:37 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:55754 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755690Ab1FPHAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:53 -0400
X-Sasl-enc: twcmFpKUen//FjBOkp3J5RdEppPioFPF16+mci4iRiP0 1308207652
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:32 2011
Message-Id: <20110616000232.538184376@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hans de Goede <hdegoede@redhat.com>, Keith Packard <keithp@keithp.com>
Subject: [36/89] drm/i915: Add a no lvds quirk for the Asus EeeBox PC EB1007
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/gpu/drm/i915/intel_lvds.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -727,6 +727,14 @@ static const struct dmi_system_id intel_
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


