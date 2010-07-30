Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708Ab0G3S3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:29:47 -0400
Received: from kroah.org ([198.145.64.141]:58199 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759903Ab0G3RzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:55:13 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:39 2010
Message-Id: <20100730175139.577445494@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:51:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [066/205] drm/radeon/kms: add quirk for ASUS HD 3600 board
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit e153b70b89770968a704eda0b55707c6066b2d44 upstream.

Connector is actually DVI rather than HDMI.

Reported-by: trapDoor <trapdoor6@gmail.com>
Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -280,6 +280,15 @@ static bool radeon_atom_apply_quirks(str
 		}
 	}
 
+	/* ASUS HD 3600 board lists the DVI port as HDMI */
+	if ((dev->pdev->device == 0x9598) &&
+	    (dev->pdev->subsystem_vendor == 0x1043) &&
+	    (dev->pdev->subsystem_device == 0x01e4)) {
+		if (*connector_type == DRM_MODE_CONNECTOR_HDMIA) {
+			*connector_type = DRM_MODE_CONNECTOR_DVII;
+		}
+	}
+
 	/* ASUS HD 3450 board lists the DVI port as HDMI */
 	if ((dev->pdev->device == 0x95C5) &&
 	    (dev->pdev->subsystem_vendor == 0x1043) &&


