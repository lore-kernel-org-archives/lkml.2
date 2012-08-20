Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab2HTEOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:14:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38485 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242Ab2HTD6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 23:58:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 14/32] drm/radeon: fix bank tiling parameters on cayman
Date: Sun, 19 Aug 2012 20:57:10 -0700
Message-Id: <20120820035649.843716434@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035647.862247088@linuxfoundation.org>
References: <20120820035647.862247088@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -880,10 +880,18 @@ static void cayman_gpu_init(struct radeo
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


