Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab2JNOnb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:43:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46497 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932181Ab2JNOnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:23 -0400
Message-Id: <20121014143543.432619480@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:44 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 071/147] drm/radeon: only adjust default clocks on NI GPUs
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 2e3b3b105ab3bb5b6a37198da4f193cd13781d13 upstream.

SI asics store voltage information differently so we
don't have a way to deal with it properly yet.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_pm.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/radeon_pm.c
index c15e505..e024435 100644
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -521,7 +521,9 @@ void radeon_pm_suspend(struct radeon_device *rdev)
 void radeon_pm_resume(struct radeon_device *rdev)
 {
 	/* set up the default clocks if the MC ucode is loaded */
-	if (ASIC_IS_DCE5(rdev) && rdev->mc_fw) {
+	if ((rdev->family >= CHIP_BARTS) &&
+	    (rdev->family <= CHIP_CAYMAN) &&
+	    rdev->mc_fw) {
 		if (rdev->pm.default_vddc)
 			radeon_atom_set_voltage(rdev, rdev->pm.default_vddc,
 						SET_VOLTAGE_TYPE_ASIC_VDDC);
@@ -576,7 +578,9 @@ int radeon_pm_init(struct radeon_device *rdev)
 		radeon_pm_print_states(rdev);
 		radeon_pm_init_profile(rdev);
 		/* set up the default clocks if the MC ucode is loaded */
-		if (ASIC_IS_DCE5(rdev) && rdev->mc_fw) {
+		if ((rdev->family >= CHIP_BARTS) &&
+		    (rdev->family <= CHIP_CAYMAN) &&
+		    rdev->mc_fw) {
 			if (rdev->pm.default_vddc)
 				radeon_atom_set_voltage(rdev, rdev->pm.default_vddc,
 							SET_VOLTAGE_TYPE_ASIC_VDDC);


