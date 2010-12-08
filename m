Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab0LHBpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:45:24 -0500
Received: from kroah.org ([198.145.64.141]:48736 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932148Ab0LHBAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:13 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:29 2010
Message-Id: <20101208005729.437949137@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [081/289] drm/radeon/kms: MC vram map needs to be >= pci aperture size
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit b7d8cce5b558e0c0aa6898c9865356481598b46d upstream.

The vram map in the radeon memory controller needs to be
>= the pci aperture size.  Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=28402

The problematic cards in the above bug have 64 MB of vram,
but the pci aperture is 128 MB and the MC vram map was only
64 MB.  This can lead to hangs.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/r100.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -2318,6 +2318,9 @@ void r100_vram_init_sizes(struct radeon_
 		/* Fix for RN50, M6, M7 with 8/16/32(??) MBs of VRAM - 
 		 * Novell bug 204882 + along with lots of ubuntu ones
 		 */
+		if (rdev->mc.aper_size > config_aper_size)
+			config_aper_size = rdev->mc.aper_size;
+
 		if (config_aper_size > rdev->mc.real_vram_size)
 			rdev->mc.mc_vram_size = config_aper_size;
 		else


