Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965037Ab2JKCSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:18:40 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40267 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964954Ab2JKCPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:15:52 -0400
X-Sasl-enc: Op+nG7cyoHeOf7nvYQB9RfYXxEj1gmWYdWQEnwSA21OQ 1349921751
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 56/84] drm/radeon: only adjust default clocks on NI GPUs
Date: Thu, 11 Oct 2012 11:03:40 +0900
Message-Id: <20121011015427.147917547@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -535,7 +535,9 @@ void radeon_pm_suspend(struct radeon_dev
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
@@ -590,7 +592,9 @@ int radeon_pm_init(struct radeon_device
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


