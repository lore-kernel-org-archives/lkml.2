Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033153Ab2I1VVF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:21:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47839 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964993Ab2I1Ua1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:30:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 158/218] drm/radeon: convert radeon vfct code to use acpi_get_table_with_size
Date: Fri, 28 Sep 2012 13:16:15 -0700
Message-Id: <20120928201519.668847102@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 7c3906d04a4587dceaa78cc1ae6b14e6454ee02a upstream.

Allows us to verify the table size.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_bios.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_bios.c
+++ b/drivers/gpu/drm/radeon/radeon_bios.c
@@ -554,13 +554,12 @@ static bool radeon_acpi_vfct_bios(struct
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
@@ -597,7 +596,6 @@ static bool radeon_acpi_vfct_bios(struct
 	ret = !!rdev->bios;
 
 out_unmap:
-	/* uh, no idea what to do here... */
 	return ret;
 }
 #else


