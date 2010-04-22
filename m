Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557Ab0DVUdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:33:17 -0400
Received: from kroah.org ([198.145.64.141]:59390 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757877Ab0DVT7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:59:37 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:05 2010
Message-Id: <20100422195405.472999964@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:53:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [006/139] drm/radeon/kms: never treat rs4xx as AGP
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit f95df9ca6896978108201a77422a1ae2cdc595ec upstream.

RS4xx+ IGP chips use an internal gart, however,
some of them have the agp cap bits set in their pci
configs.  Make sure to clear the AGP flag as AGP will
not work with them.

Should fix fdo bug 27225

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_device.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -655,6 +655,14 @@ int radeon_device_init(struct radeon_dev
 		return r;
 	radeon_check_arguments(rdev);
 
+	/* all of the newer IGP chips have an internal gart
+	 * However some rs4xx report as AGP, so remove that here.
+	 */
+	if ((rdev->family >= CHIP_RS400) &&
+	    (rdev->flags & RADEON_IS_IGP)) {
+		rdev->flags &= ~RADEON_IS_AGP;
+	}
+
 	if (rdev->flags & RADEON_IS_AGP && radeon_agpmode == -1) {
 		radeon_agp_disable(rdev);
 	}


