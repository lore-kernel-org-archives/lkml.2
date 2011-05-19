Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933848Ab1ESSHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:07:52 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:39739 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933824Ab1ESSHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:07:48 -0400
X-Sasl-enc: ca9SMyRP2ZForD2pCOx7QcxHRG5+2Hzun56aqIR5oPnr 1305828467
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:55 2011
Message-Id: <20110519180554.959104986@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:04:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [07/71] drm/radeon/kms: add pci id to acer travelmate quirk for 5730
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 4f87af46107499415afd238be104587b5a9d7ac3 upstream.

Fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=34082

Reported by: Sampo Laaksonen <zhamahn@gmail.com>
Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -431,7 +431,7 @@ static bool radeon_atom_apply_quirks(str
 		}
 	}
 
-	/* Acer laptop (Acer TravelMate 5730G) has an HDMI port
+	/* Acer laptop (Acer TravelMate 5730/5730G) has an HDMI port
 	 * on the laptop and a DVI port on the docking station and
 	 * both share the same encoder, hpd pin, and ddc line.
 	 * So while the bios table is technically correct,
@@ -440,7 +440,7 @@ static bool radeon_atom_apply_quirks(str
 	 * with different crtcs which isn't possible on the hardware
 	 * side and leaves no crtcs for LVDS or VGA.
 	 */
-	if ((dev->pdev->device == 0x95c4) &&
+	if (((dev->pdev->device == 0x95c4) || (dev->pdev->device == 0x9591)) &&
 	    (dev->pdev->subsystem_vendor == 0x1025) &&
 	    (dev->pdev->subsystem_device == 0x013c)) {
 		if ((*connector_type == DRM_MODE_CONNECTOR_DVII) &&


