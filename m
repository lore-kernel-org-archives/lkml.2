Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab2IQAy3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:54:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33995 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754849Ab2IQAvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:51:40 -0400
Message-Id: <20120917003629.711906671@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:36:50 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 025/135] drm/radeon: force dma32 to fix regression rs4xx,rs6xx,rs740
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit 4a2b6662c3632176b4fdf012243dd3751367bf1f upstream.

It seems some of those IGP dislike non dma32 page despite what
documentation says. Fix regression since we allowed non dma32
pages. It seems it only affect some revision of those IGP chips
as we don't know which one just force dma32 for all of them.

https://bugzilla.redhat.com/show_bug.cgi?id=785375

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index d2e2438..33da8bf 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -1051,7 +1051,7 @@ int radeon_device_init(struct radeon_device *rdev,
 	if (rdev->flags & RADEON_IS_AGP)
 		rdev->need_dma32 = true;
 	if ((rdev->flags & RADEON_IS_PCI) &&
-	    (rdev->family < CHIP_RS400))
+	    (rdev->family <= CHIP_RS740))
 		rdev->need_dma32 = true;
 
 	dma_bits = rdev->need_dma32 ? 32 : 40;


