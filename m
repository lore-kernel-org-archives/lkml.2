Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965697Ab1KJDpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:45:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44779 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965430Ab1KJDpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:45:31 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:02 2011
Message-Id: <20111109213202.163614996@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [197/264] drm/radeon/kms: Add MSI quirk for HP RS690
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit b362105f7f5223fa4d2e03ceeea0e51da754ccc6 upstream.

Some HP laptops only seem to work with MSIs.  This
looks like a platform/bios bug.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=37679

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_irq_kms.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_irq_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_irq_kms.c
@@ -118,6 +118,13 @@ static bool radeon_msi_ok(struct radeon_
 	if (rdev->flags & RADEON_IS_AGP)
 		return false;
 
+	/* Quirks */
+	/* HP RS690 only seems to work with MSIs. */
+	if ((rdev->pdev->device == 0x791f) &&
+	    (rdev->pdev->subsystem_vendor == 0x103c) &&
+	    (rdev->pdev->subsystem_device == 0x30c2))
+		return true;
+
 	if (rdev->flags & RADEON_IS_IGP) {
 		/* APUs work fine with MSIs */
 		if (rdev->family >= CHIP_PALM)


