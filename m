Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab2IIXQu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:16:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51366 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756154Ab2IIXQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:46 -0400
Message-Id: <20120909224158.428408483@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:46 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 56/95] drm/radeon/kms: extend the Fujitsu D3003-S2 board connector quirk to
 cover later silicon stepping
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>

commit 52e9b39d9a89ae33662596bd30e62dd56bddbe73 upstream.

There is a more recent APU stepping with a new PCI ID
shipping in the same board by Fujitsu which needs the
same quirk to correctly mark the back plane connectors.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_atombios.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index f9c21f9..d67d4f3 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -452,7 +452,7 @@ static bool radeon_atom_apply_quirks(struct drm_device *dev,
 	}
 
 	/* Fujitsu D3003-S2 board lists DVI-I as DVI-D and VGA */
-	if ((dev->pdev->device == 0x9802) &&
+	if (((dev->pdev->device == 0x9802) || (dev->pdev->device == 0x9806)) &&
 	    (dev->pdev->subsystem_vendor == 0x1734) &&
 	    (dev->pdev->subsystem_device == 0x11bd)) {
 		if (*connector_type == DRM_MODE_CONNECTOR_VGA) {


