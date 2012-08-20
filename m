Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab2HTD6p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 23:58:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59366 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab2HTD6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 23:58:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 15/32] drm/radeon: fix bank tiling parameters on evergreen
Date: Sun, 19 Aug 2012 20:57:11 -0700
Message-Id: <20120820035649.985201712@linuxfoundation.org>
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

commit c8d15edc17d836686d1f071e564800e1a2724fa6 upstream.

Handle the 16 bank case.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -2085,10 +2085,18 @@ static void evergreen_gpu_init(struct ra
 	if (rdev->flags & RADEON_IS_IGP)
 		rdev->config.evergreen.tile_config |= 1 << 4;
 	else {
-		if ((mc_arb_ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT)
-			rdev->config.evergreen.tile_config |= 1 << 4;
-		else
+		switch ((mc_arb_ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT) {
+		case 0: /* four banks */
 			rdev->config.evergreen.tile_config |= 0 << 4;
+			break;
+		case 1: /* eight banks */
+			rdev->config.evergreen.tile_config |= 1 << 4;
+			break;
+		case 2: /* sixteen banks */
+		default:
+			rdev->config.evergreen.tile_config |= 2 << 4;
+			break;
+		}
 	}
 	rdev->config.evergreen.tile_config |=
 		((mc_arb_ramcfg & BURSTLENGTH_MASK) >> BURSTLENGTH_SHIFT) << 8;


