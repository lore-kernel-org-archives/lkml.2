Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab2IIX2g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:28:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51284 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756044Ab2IIXQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:32 -0400
Message-Id: <20120909224158.820153827@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:49 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>
Subject: [ 59/95] drm/radeon: convert radeon vfct code to use acpi_get_table_with_size
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 7c3906d04a4587dceaa78cc1ae6b14e6454ee02a upstream.

Allows us to verify the table size.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_bios.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_bios.c b/drivers/gpu/drm/radeon/radeon_bios.c
index a32232f..ab0b2f7 100644
--- a/drivers/gpu/drm/radeon/radeon_bios.c
+++ b/drivers/gpu/drm/radeon/radeon_bios.c
@@ -482,13 +482,12 @@ static bool radeon_acpi_vfct_bios(struct radeon_device *rdev)
 {
 	bool ret = false;
 	struct acpi_table_header *hdr;
-	/* acpi_get_table_with_size is not exported :( */
-	acpi_size tbl_size = 0x7fffffff;
+	acpi_size tbl_size;
 	UEFI_ACPI_VFCT *vfct;
 	GOP_VBIOS_CONTENT *vbios;
 	VFCT_IMAGE_HEADER *vhdr;
 
-	if (!ACPI_SUCCESS(acpi_get_table("VFCT", 1, &hdr)))
+	if (!ACPI_SUCCESS(acpi_get_table_with_size("VFCT", 1, &hdr, &tbl_size)))
 		return false;
 	if (tbl_size < sizeof(UEFI_ACPI_VFCT)) {
 		DRM_ERROR("ACPI VFCT table present but broken (too short #1)\n");
@@ -525,7 +524,6 @@ static bool radeon_acpi_vfct_bios(struct radeon_device *rdev)
 	ret = !!rdev->bios;
 
 out_unmap:
-	/* uh, no idea what to do here... */
 	return ret;
 }
 #else


