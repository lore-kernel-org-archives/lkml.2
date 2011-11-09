Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935269Ab1KJEzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:55:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42807 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935257Ab1KJDbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:31:02 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:21 2011
Message-Id: <20111109212721.014052476@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [203/262] drm/radeon/kms: Add MSI quirk for Dell RS690
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 01e718ec194e30b3e8eb3858c742c13649757efc upstream.

Some Dell laptops only seem to work with MSIs.  This
looks like a platform/bios bug.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=37679

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_irq_kms.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_irq_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_irq_kms.c
@@ -125,6 +125,12 @@ static bool radeon_msi_ok(struct radeon_
 	    (rdev->pdev->subsystem_device == 0x30c2))
 		return true;
 
+	/* Dell RS690 only seems to work with MSIs. */
+	if ((rdev->pdev->device == 0x791f) &&
+	    (rdev->pdev->subsystem_vendor == 0x1028) &&
+	    (rdev->pdev->subsystem_device == 0x01fd))
+		return true;
+
 	if (rdev->flags & RADEON_IS_IGP) {
 		/* APUs work fine with MSIs */
 		if (rdev->family >= CHIP_PALM)


