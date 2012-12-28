Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab2L1TSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:18:14 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55183 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754492Ab2L1TSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:18:06 -0500
Message-Id: <20121228190356.683678436@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:37 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 127/173] drm/radeon: fix amd afusion gpu setup aka sumo v2
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit bd25f0783dc3fb72e1e2779c2b99b2d34b67fa8a upstream.

Set the proper number of tile pipe that should be a multiple of
pipe depending on the number of se engine.

Fix:
https://bugs.freedesktop.org/show_bug.cgi?id=56405
https://bugs.freedesktop.org/show_bug.cgi?id=56720

v2: Don't change sumo2

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
[bwh: Backported to 3.2: don't define/use *_GB_ADDR_CONFIG_GOLDEN]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/evergreen.c  |    8 ++++----
 drivers/gpu/drm/radeon/evergreend.h |    2 ++
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1730,7 +1730,7 @@ static void evergreen_gpu_init(struct ra
 	case CHIP_SUMO:
 		rdev->config.evergreen.num_ses = 1;
 		rdev->config.evergreen.max_pipes = 4;
-		rdev->config.evergreen.max_tile_pipes = 2;
+		rdev->config.evergreen.max_tile_pipes = 4;
 		if (rdev->pdev->device == 0x9648)
 			rdev->config.evergreen.max_simds = 3;
 		else if ((rdev->pdev->device == 0x9647) ||
@@ -1819,7 +1819,7 @@ static void evergreen_gpu_init(struct ra
 		break;
 	case CHIP_CAICOS:
 		rdev->config.evergreen.num_ses = 1;
-		rdev->config.evergreen.max_pipes = 4;
+		rdev->config.evergreen.max_pipes = 2;
 		rdev->config.evergreen.max_tile_pipes = 2;
 		rdev->config.evergreen.max_simds = 2;
 		rdev->config.evergreen.max_backends = 1 * rdev->config.evergreen.num_ses;


