Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab2HTEAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:00:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54493 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab2HTEAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:00:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 17/46] drm/radeon: fix bank tiling parameters on cayman
Date: Sun, 19 Aug 2012 20:58:53 -0700
Message-Id: <20120820035834.660409803@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035832.274275502@linuxfoundation.org>
References: <20120820035832.274275502@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 5b23c9045a8b61352986270b2d109edf5085e113 upstream.

Handle the 16 bank case.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/ni.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -574,10 +574,18 @@ static void cayman_gpu_init(struct radeo
 	if (rdev->flags & RADEON_IS_IGP)
 		rdev->config.cayman.tile_config |= 1 << 4;
 	else {
-		if ((mc_arb_ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT)
-			rdev->config.cayman.tile_config |= 1 << 4;
-		else
+		switch ((mc_arb_ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT) {
+		case 0: /* four banks */
 			rdev->config.cayman.tile_config |= 0 << 4;
+			break;
+		case 1: /* eight banks */
+			rdev->config.cayman.tile_config |= 1 << 4;
+			break;
+		case 2: /* sixteen banks */
+		default:
+			rdev->config.cayman.tile_config |= 2 << 4;
+			break;
+		}
 	}
 	rdev->config.cayman.tile_config |=
 		((gb_addr_config & PIPE_INTERLEAVE_SIZE_MASK) >> PIPE_INTERLEAVE_SIZE_SHIFT) << 8;


