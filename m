Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab1H0O7b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:59:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790Ab1H0O72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:59:28 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 14:50:56 2011
Message-Id: <20110826215055.994347118@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:49:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Reim <reimth@gmail.com>, Chris Routh <routhy@gmail.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [30/35] drm/radeon: Extended DDC Probing for Toshiba L300D Radeon Mobility X1100 HDMI-A Connector
In-Reply-To: <20110826215139.GA11498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Reim <reimth@googlemail.com>

commit f2b60717e692550bf753a5d64a5b69ea430fc832 upstream.

Toshiba Satellite L300D with ATI Mobility Radeon X1100 sends data
   to i2c bus for a HDMI connector that is not implemented/existent
   on the notebook's board.

   Fix by applying extented DDC probing for this connector.

   Requires [PATCH] drm/radeon: Extended DDC Probing for Connectors
   with Improperly Wired DDC Lines

   Tested for kernel 2.6.38 on Toshiba Satellite L300D notebook

   BugLink: http://bugs.launchpad.net/bugs/826677

Signed-off-by: Thomas Reim <reimth@gmail.com>
Acked-by: Chris Routh <routhy@gmail.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_connectors.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -466,6 +466,16 @@ static bool radeon_connector_needs_exten
 		    (supported_device == ATOM_DEVICE_DFP2_SUPPORT))
 			return true;
 	}
+	/* TOSHIBA Satellite L300D with ATI Mobility Radeon x1100
+	 * (RS690M) sends data to i2c bus for a HDMI connector that
+	 * is not implemented */
+	if ((dev->pdev->device == 0x791f) &&
+	    (dev->pdev->subsystem_vendor == 0x1179) &&
+	    (dev->pdev->subsystem_device == 0xff68)) {
+		if ((connector_type == DRM_MODE_CONNECTOR_HDMIA) &&
+		    (supported_device == ATOM_DEVICE_DFP2_SUPPORT))
+			return true;
+	}
 
 	/* Default: no EDID header probe required for DDC probing */
 	return false;


