Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456Ab0JVTHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:07:22 -0400
Received: from kroah.org ([198.145.64.141]:34299 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759445Ab0JVS4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:49 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:33 2010
Message-Id: <20101022185233.644252976@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [070/103] drm/radeon/kms: add quirk for MSI K9A2GM motherboard
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit f36fce0f49ed40f3e843d45fa53d476d63444b58 upstream.

Board has no digital connectors

Reported-by: Andy Walls <awalls@md.metrocast.net>
Tested-by: Andy Walls <awalls@md.metrocast.net>
Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -226,6 +226,15 @@ static bool radeon_atom_apply_quirks(str
 			*connector_type = DRM_MODE_CONNECTOR_DVID;
 	}
 
+	/* MSI K9A2GM V2/V3 board has no HDMI or DVI */
+	if ((dev->pdev->device == 0x796e) &&
+	    (dev->pdev->subsystem_vendor == 0x1462) &&
+	    (dev->pdev->subsystem_device == 0x7302)) {
+		if ((supported_device == ATOM_DEVICE_DFP2_SUPPORT) ||
+		    (supported_device == ATOM_DEVICE_DFP3_SUPPORT))
+			return false;
+	}
+
 	/* a-bit f-i90hd - ciaranm on #radeonhd - this board has no DVI */
 	if ((dev->pdev->device == 0x7941) &&
 	    (dev->pdev->subsystem_vendor == 0x147b) &&


