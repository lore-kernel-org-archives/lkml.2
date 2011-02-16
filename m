Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483Ab1BPAv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:51:59 -0500
Received: from kroah.org ([198.145.64.141]:46245 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933375Ab1BPAvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:51:54 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:15 2011
Message-Id: <20110216002115.091541263@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:22:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@gmail.com>
Subject: [patch 161/176] drm/radeon/kms: make the mac rv630 quirk generic
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit be23da8ad219650517cbbb7acbeaeb235667113a upstream.

Seems some other boards do this as well.

Reported-by: Andrea Merello <andrea.merello@gmail.com>
Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -387,15 +387,11 @@ static bool radeon_atom_apply_quirks(str
 			*line_mux = 0x90;
 	}
 
-	/* mac rv630 */
-	if ((dev->pdev->device == 0x9588) &&
-	    (dev->pdev->subsystem_vendor == 0x106b) &&
-	    (dev->pdev->subsystem_device == 0x00a6)) {
-		if ((supported_device == ATOM_DEVICE_TV1_SUPPORT) &&
-		    (*connector_type == DRM_MODE_CONNECTOR_DVII)) {
-			*connector_type = DRM_MODE_CONNECTOR_9PinDIN;
-			*line_mux = CONNECTOR_7PIN_DIN_ENUM_ID1;
-		}
+	/* mac rv630, rv730, others */
+	if ((supported_device == ATOM_DEVICE_TV1_SUPPORT) &&
+	    (*connector_type == DRM_MODE_CONNECTOR_DVII)) {
+		*connector_type = DRM_MODE_CONNECTOR_9PinDIN;
+		*line_mux = CONNECTOR_7PIN_DIN_ENUM_ID1;
 	}
 
 	/* ASUS HD 3600 XT board lists the DVI port as HDMI */


