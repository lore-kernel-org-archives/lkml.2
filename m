Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933690Ab0HXXJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:09:43 -0400
Received: from kroah.org ([198.145.64.141]:32783 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933635Ab0HXXDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:03:25 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:09 2010
Message-Id: <20100824224509.146048054@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:45:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [091/114] drm/radeon/kms: dont enable MSIs on AGP boards
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit da7be684c55dbaeebfc1a048d5faf52d52cb3c1f upstream.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=29327

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_irq_kms.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_irq_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_irq_kms.c
@@ -121,11 +121,12 @@ int radeon_irq_kms_init(struct radeon_de
 	 * chips.  Disable MSI on them for now.
 	 */
 	if ((rdev->family >= CHIP_RV380) &&
-	    (!(rdev->flags & RADEON_IS_IGP))) {
+	    (!(rdev->flags & RADEON_IS_IGP)) &&
+	    (!(rdev->flags & RADEON_IS_AGP))) {
 		int ret = pci_enable_msi(rdev->pdev);
 		if (!ret) {
 			rdev->msi_enabled = 1;
-			DRM_INFO("radeon: using MSI.\n");
+			dev_info(rdev->dev, "radeon: using MSI.\n");
 		}
 	}
 	rdev->irq.installed = true;


