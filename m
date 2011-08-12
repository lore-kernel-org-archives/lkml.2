Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab1HNQGx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:06:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36393 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902Ab1HNQGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:06:46 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:54 2011
Message-Id: <20110812210553.960082932@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Reim <reimth@gmail.com>,
        Stephen Michaels <Stephen.Micheals@gmail.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [21/90] drm/radeon: Extended DDC Probing for ECS A740GM-M DVI-D Connector
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Reim <reimth@gmail.com>

commit a81b31e9fc98e067b7e7f1244861c97e44268e2d upstream.

   ECS A740GM-M with ATI RADEON 2100 sends data to i2c bus
   for a DVI connector that is not implemented/existent on the board.

   Fix by applying extented DDC probing for this connector.

   Requires [PATCH] drm/radeon: Extended DDC Probing for Connectors
   with Improperly Wired DDC Lines

   Tested for kernel 2.6.38 on Asus ECS A740GM-M board

   BugLink: http://bugs.launchpad.net/bugs/810926

Signed-off-by: Thomas Reim <reimth@gmail.com>
Reviewed-by: Alex Deucher <alexdeucher@gmail.com>
Acked-by: Stephen Michaels <Stephen.Micheals@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_connectors.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -455,6 +455,15 @@ static bool radeon_connector_needs_exten
 		    (supported_device == ATOM_DEVICE_DFP2_SUPPORT))
 			return true;
 	}
+	/* ECS A740GM-M with ATI RADEON 2100 sends data to i2c bus
+	 * for a DVI connector that is not implemented */
+	if ((dev->pdev->device == 0x796e) &&
+	    (dev->pdev->subsystem_vendor == 0x1019) &&
+	    (dev->pdev->subsystem_device == 0x2615)) {
+		if ((connector_type == DRM_MODE_CONNECTOR_DVID) &&
+		    (supported_device == ATOM_DEVICE_DFP2_SUPPORT))
+			return true;
+	}
 
 	/* Default: no EDID header probe required for DDC probing */
 	return false;


