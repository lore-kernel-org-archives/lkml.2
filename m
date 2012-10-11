Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964977Ab2JKCQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:16:09 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55095 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964875Ab2JKCQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:16:02 -0400
X-Sasl-enc: JFaWB6/7MDKLjy7nrfnU0PHFF3a6SpZ8BldjXB/p27ps 1349921761
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 58/84] drm/radeon: force MSIs on RS690 asics
Date: Thu, 11 Oct 2012 11:03:42 +0900
Message-Id: <20121011015427.523787869@linuxfoundation.org>
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

commit fb6ca6d154cdcd53e7f27f8dbba513830372699b upstream.

There are so many quirks, lets just try and force
this for all RS690s.  See:
https://bugs.freedesktop.org/show_bug.cgi?id=37679

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_irq_kms.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_irq_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_irq_kms.c
@@ -149,6 +149,10 @@ static bool radeon_msi_ok(struct radeon_
 	    (rdev->pdev->subsystem_device == 0x0185))
 		return true;
 
+	/* try and enable MSIs by default on all RS690s */
+	if (rdev->family == CHIP_RS690)
+		return true;
+
 	/* RV515 seems to have MSI issues where it loses
 	 * MSI rearms occasionally. This leads to lockups and freezes.
 	 * disable it by default.


