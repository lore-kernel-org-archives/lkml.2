Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab1FPHLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:11:15 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:57259 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756923Ab1FPHLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:11:10 -0400
X-Sasl-enc: A+bXrVO99nrGx54sZo9lp+io4bXmCrA+SmRhcvToQaOv 1308208269
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:10 2011
Message-Id: <20110616002910.052833196@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:28:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hans de Goede <hdegoede@redhat.com>, Keith Packard <keithp@keithp.com>
Subject: [62/85] drm/i915: Add a no lvds quirk for the Asus EeeBox PC EB1007
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -915,6 +915,14 @@ static const struct dmi_system_id intel_
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


