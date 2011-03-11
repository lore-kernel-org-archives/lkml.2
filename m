Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab1CKVNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 16:13:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302Ab1CKVNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 16:13:04 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 4/4] ACPI: Make sure the FADT is at least rev 2 before using the reset register
Date: Fri, 11 Mar 2011 16:12:20 -0500
Message-Id: <1299877940-6870-4-git-send-email-mjg@redhat.com>
In-Reply-To: <1299877940-6870-1-git-send-email-mjg@redhat.com>
References: <1299877940-6870-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reset register was only introduced with version 2 of the FADT, so we
should check that the FADT revision before trusting its contents.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/acpi/reboot.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/reboot.c b/drivers/acpi/reboot.c
index 4870aaa..a6c77e8b 100644
--- a/drivers/acpi/reboot.c
+++ b/drivers/acpi/reboot.c
@@ -15,6 +15,11 @@ void acpi_reboot(void)
 
 	rr = &acpi_gbl_FADT.reset_register;
 
+	/* ACPI reset register was only introduced with v2 of the FADT */
+
+	if (acpi_gbl_FADT.header.revision < 2)
+		return;
+
 	/* Is the reset register supported? The spec says we should be
 	 * checking the bit width and bit offset, but Windows ignores
 	 * these fields */
-- 
1.7.4.1

