Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469Ab2BAVrM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:47:12 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43355 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757086Ab2BAVIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:08:51 -0500
X-Sasl-enc: VIb9aaniwdLb0QFKlxG8LFCTeHKFaVy6JlRWpEn1DKRs 1328130530
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:57:38 2012
Message-Id: <20120201205738.099652830@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:55:47 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dmitry Podgorny <pasis.uax@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [07/65] drm/radeon/kms: Add an MSI quirk for Dell RS690
In-Reply-To: <20120201210236.GA25966@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 44517c44496062180a6376cc704b33129441ce60 upstream.

Interrupts only work with MSIs.
https://bugs.freedesktop.org/show_bug.cgi?id=37679

Reported-by: Dmitry Podgorny <pasis.uax@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_irq_kms.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_irq_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_irq_kms.c
@@ -134,6 +134,12 @@ static bool radeon_msi_ok(struct radeon_
 	/* Dell RS690 only seems to work with MSIs. */
 	if ((rdev->pdev->device == 0x791f) &&
 	    (rdev->pdev->subsystem_vendor == 0x1028) &&
+	    (rdev->pdev->subsystem_device == 0x01fc))
+		return true;
+
+	/* Dell RS690 only seems to work with MSIs. */
+	if ((rdev->pdev->device == 0x791f) &&
+	    (rdev->pdev->subsystem_vendor == 0x1028) &&
 	    (rdev->pdev->subsystem_device == 0x01fd))
 		return true;
 


