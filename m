Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964957Ab2DSVOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:14:41 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55440 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964945Ab2DSVOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:14:36 -0400
Message-Id: <20120419210616.089329064@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:07:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 58/59] drm/radeon: disable MSI on RV515
In-Reply-To: <20120419210623.GA12156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 16a5e32b83fd946312b9b13590c75d20c95c5202 upstream.

My rv515 card is very flaky with msi enabled. Every so often it loses a rearm
and never comes back, manually banging the rearm brings it back.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_irq_kms.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_irq_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_irq_kms.c
@@ -143,6 +143,12 @@ static bool radeon_msi_ok(struct radeon_
 	    (rdev->pdev->subsystem_device == 0x01fd))
 		return true;
 
+	/* RV515 seems to have MSI issues where it loses
+	 * MSI rearms occasionally. This leads to lockups and freezes.
+	 * disable it by default.
+	 */
+	if (rdev->family == CHIP_RV515)
+		return false;
 	if (rdev->flags & RADEON_IS_IGP) {
 		/* APUs work fine with MSIs */
 		if (rdev->family >= CHIP_PALM)


