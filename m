Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345Ab1BPAzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:55:51 -0500
Received: from kroah.org ([198.145.64.141]:46233 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933388Ab1BPAvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:51:51 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:14 2011
Message-Id: <20110216002114.903808654@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:22:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [patch 159/176] drm/radeon/kms: add quirk for Mac Radeon HD 2600 card
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit f598aa7593427ffe3a61e7767c34bd695a5e7ed0 upstream.

Reported-by: 屋国遥 <hyagni@gmail.com>
Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -388,6 +388,17 @@ static bool radeon_atom_apply_quirks(str
 			*line_mux = 0x90;
 	}
 
+	/* mac rv630 */
+	if ((dev->pdev->device == 0x9588) &&
+	    (dev->pdev->subsystem_vendor == 0x106b) &&
+	    (dev->pdev->subsystem_device == 0x00a6)) {
+		if ((supported_device == ATOM_DEVICE_TV1_SUPPORT) &&
+		    (*connector_type == DRM_MODE_CONNECTOR_DVII)) {
+			*connector_type = DRM_MODE_CONNECTOR_9PinDIN;
+			*line_mux = CONNECTOR_7PIN_DIN_ENUM_ID1;
+		}
+	}
+
 	/* ASUS HD 3600 XT board lists the DVI port as HDMI */
 	if ((dev->pdev->device == 0x9598) &&
 	    (dev->pdev->subsystem_vendor == 0x1043) &&


