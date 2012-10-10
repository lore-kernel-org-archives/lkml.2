Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234Ab2JKAYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:24:08 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56066 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933222Ab2JKAYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:24:03 -0400
X-Sasl-enc: qi7lYIjAsDgMTNtcSBbBlPjRL2tnC0+N/LiMDu15pHgr 1349915042
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 081/122] drm/radeon: Add MSI quirk for gateway RS690
Date: Thu, 11 Oct 2012 07:54:07 +0900
Message-Id: <20121010225352.658006010@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 3a6d59df80897cc87812b6826d70085905bed013 upstream.

Fixes another system on:
https://bugs.freedesktop.org/show_bug.cgi?id=37679

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_irq_kms.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_irq_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_irq_kms.c
@@ -204,6 +204,12 @@ static bool radeon_msi_ok(struct radeon_
 	    (rdev->pdev->subsystem_device == 0x01fd))
 		return true;
 
+	/* Gateway RS690 only seems to work with MSIs. */
+	if ((rdev->pdev->device == 0x791f) &&
+	    (rdev->pdev->subsystem_vendor == 0x107b) &&
+	    (rdev->pdev->subsystem_device == 0x0185))
+		return true;
+
 	/* RV515 seems to have MSI issues where it loses
 	 * MSI rearms occasionally. This leads to lockups and freezes.
 	 * disable it by default.


