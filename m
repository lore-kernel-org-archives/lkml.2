Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030817Ab2HQDcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:32:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46788 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030658Ab2HQD1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:27:00 -0400
Message-Id: <20120817030249.584241154@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 17 Aug 2012 04:03:19 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>
Subject: [ 36/37] drm/radeon: fix bank tiling parameters on cayman
In-Reply-To: <20120817030243.807605523@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 5b23c9045a8b61352986270b2d109edf5085e113 upstream.

Handle the 16 bank case.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[bwh: Backported to 3.2: adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/ni.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -804,10 +804,18 @@ static void cayman_gpu_init(struct radeo
 		rdev->config.cayman.tile_config |= (3 << 0);
 		break;
 	}
-	if ((mc_arb_ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT)
-		rdev->config.cayman.tile_config |= 1 << 4;
-	else
+	switch ((mc_arb_ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT) {
+	case 0: /* four banks */
 		rdev->config.cayman.tile_config |= 0 << 4;
+		break;
+	case 1: /* eight banks */
+		rdev->config.cayman.tile_config |= 1 << 4;
+		break;
+	case 2: /* sixteen banks */
+	default:
+		rdev->config.cayman.tile_config |= 2 << 4;
+		break;
+	}
 	rdev->config.cayman.tile_config |=
 		((gb_addr_config & PIPE_INTERLEAVE_SIZE_MASK) >> PIPE_INTERLEAVE_SIZE_SHIFT) << 8;
 	rdev->config.cayman.tile_config |=


