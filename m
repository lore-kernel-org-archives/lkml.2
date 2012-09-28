Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031810Ab2I1VWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:22:31 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:54963 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032786Ab2I1UaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:30:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 160/218] drm/radeon: force dma32 to fix regression rs4xx,rs6xx,rs740
Date: Fri, 28 Sep 2012 13:16:17 -0700
Message-Id: <20120928201519.920834042@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit 4a2b6662c3632176b4fdf012243dd3751367bf1f upstream.

It seems some of those IGP dislike non dma32 page despite what
documentation says. Fix regression since we allowed non dma32
pages. It seems it only affect some revision of those IGP chips
as we don't know which one just force dma32 for all of them.

https://bugzilla.redhat.com/show_bug.cgi?id=785375

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -772,7 +772,7 @@ int radeon_device_init(struct radeon_dev
 	if (rdev->flags & RADEON_IS_AGP)
 		rdev->need_dma32 = true;
 	if ((rdev->flags & RADEON_IS_PCI) &&
-	    (rdev->family < CHIP_RS400))
+	    (rdev->family <= CHIP_RS740))
 		rdev->need_dma32 = true;
 
 	dma_bits = rdev->need_dma32 ? 32 : 40;


