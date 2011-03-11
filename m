Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab1CKVNH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 16:13:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168Ab1CKVND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 16:13:03 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/4] ACPICA: Fix access width for reset vector
Date: Fri, 11 Mar 2011 16:12:18 -0500
Message-Id: <1299877940-6870-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1299877940-6870-1-git-send-email-mjg@redhat.com>
References: <1299877940-6870-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Section 4.7.3.6 of the ACPI specification requires that the register width
of the reset vector be 8 bits. Windows simply hardcodes the access to be
a byte and ignores the width provided in the FADT, so make sure that we
do the same.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/acpi/acpica/hwxface.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/acpica/hwxface.c b/drivers/acpi/acpica/hwxface.c
index 6f98d21..f75f81a 100644
--- a/drivers/acpi/acpica/hwxface.c
+++ b/drivers/acpi/acpica/hwxface.c
@@ -80,14 +80,14 @@ acpi_status acpi_reset(void)
 
 	if (reset_reg->space_id == ACPI_ADR_SPACE_SYSTEM_IO) {
 		/*
-		 * For I/O space, write directly to the OSL. This bypasses the port
-		 * validation mechanism, which may block a valid write to the reset
-		 * register.
+		 * For I/O space, write directly to the OSL. This
+		 * bypasses the port validation mechanism, which may
+		 * block a valid write to the reset register. Spec
+		 * section 4.7.3.6 requires register width to be 8.
 		 */
 		status =
 		    acpi_os_write_port((acpi_io_address) reset_reg->address,
-				       acpi_gbl_FADT.reset_value,
-				       reset_reg->bit_width);
+				       acpi_gbl_FADT.reset_value, 8);
 	} else {
 		/* Write the reset value to the reset register */
 
-- 
1.7.4.1

