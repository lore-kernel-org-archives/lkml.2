Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab2JNOnf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:43:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46494 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932179Ab2JNOnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:23 -0400
Message-Id: <20121014143543.695060674@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:46 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 073/147] drm/radeon: force MSIs on RS690 asics
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

commit fb6ca6d154cdcd53e7f27f8dbba513830372699b upstream.

There are so many quirks, lets just try and force
this for all RS690s.  See:
https://bugs.freedesktop.org/show_bug.cgi?id=37679

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_irq_kms.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_irq_kms.c b/drivers/gpu/drm/radeon/radeon_irq_kms.c
index 2da4465..b06fa59 100644
--- a/drivers/gpu/drm/radeon/radeon_irq_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_irq_kms.c
@@ -208,6 +208,10 @@ static bool radeon_msi_ok(struct radeon_device *rdev)
 	    (rdev->pdev->subsystem_device == 0x0185))
 		return true;
 
+	/* try and enable MSIs by default on all RS690s */
+	if (rdev->family == CHIP_RS690)
+		return true;
+
 	/* RV515 seems to have MSI issues where it loses
 	 * MSI rearms occasionally. This leads to lockups and freezes.
 	 * disable it by default.


