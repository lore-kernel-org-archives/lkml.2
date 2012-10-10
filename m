Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752Ab2JKAlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:41:40 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49088 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932746Ab2JKAOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:14:15 -0400
X-Sasl-enc: r14V3axUm6wVqG9MaVGf6XGDcnpamEq0eoVn1X2DVz9R 1349914453
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 095/133] drm/radeon: Add MSI quirk for gateway RS690
Date: Thu, 11 Oct 2012 07:52:01 +0900
Message-Id: <20121010224911.598706240@linuxfoundation.org>
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
@@ -149,6 +149,12 @@ static bool radeon_msi_ok(struct radeon_
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


