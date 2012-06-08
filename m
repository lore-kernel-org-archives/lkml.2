Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933573Ab2FHF3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:29:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43143 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759881Ab2FHFHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:11 -0400
Message-Id: <20120608041844.216102992@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:05 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Mehdi Aqadjani Memar <m.aqadjanimemar@student.ru.nl>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 25/82] drm/radeon: fix XFX quirk
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 1ebf169ad4dc68f18cc0dab35163b0f324fc6c41 upstream.

Only override the ddc bus if the connector doesn't have
a valid one.  The existing code overrode the ddc bus for
all connectors even if it had ddc bus.

Fixes ddc on another XFX card with the same pci ids that
was broken by the quirk overwriting the correct ddc bus.

Reported-by: Mehdi Aqadjani Memar <m.aqadjanimemar@student.ru.nl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_atombios.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index f6e69b8..b1e3820 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -444,7 +444,9 @@ static bool radeon_atom_apply_quirks(struct drm_device *dev,
 	 */
 	if ((dev->pdev->device == 0x9498) &&
 	    (dev->pdev->subsystem_vendor == 0x1682) &&
-	    (dev->pdev->subsystem_device == 0x2452)) {
+	    (dev->pdev->subsystem_device == 0x2452) &&
+	    (i2c_bus->valid == false) &&
+	    !(supported_device & (ATOM_DEVICE_TV_SUPPORT | ATOM_DEVICE_CV_SUPPORT))) {
 		struct radeon_device *rdev = dev->dev_private;
 		*i2c_bus = radeon_lookup_i2c_gpio(rdev, 0x93);
 	}


