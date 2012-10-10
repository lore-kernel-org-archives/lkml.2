Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762Ab2JKAOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:14:18 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34246 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932633Ab2JKAOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:14:10 -0400
X-Sasl-enc: KjwXtrtgSrYAK9ddi/L4mSGp4UGecLt34TB1E5JZkYEB 1349914448
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 094/133] drm/radeon: only adjust default clocks on NI GPUs
Date: Thu, 11 Oct 2012 07:52:00 +0900
Message-Id: <20121010224911.416661759@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 2e3b3b105ab3bb5b6a37198da4f193cd13781d13 upstream.

SI asics store voltage information differently so we
don't have a way to deal with it properly yet.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_pm.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -555,7 +555,9 @@ void radeon_pm_suspend(struct radeon_dev
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
@@ -610,7 +612,9 @@ int radeon_pm_init(struct radeon_device
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


