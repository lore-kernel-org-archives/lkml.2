Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab2IWEj4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 00:39:56 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:59900 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab2IWEfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 00:35:30 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 21/23] tools/power/acpi/acpidump: version 20071116
Date: Sun, 23 Sep 2012 00:34:09 -0400
Message-Id: <39a55ff2c34a11ab9bbc8ba6f4dfb5d366cb2532.1348371388.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.12.1.396.g16eed7c
In-Reply-To: <1348374851-20378-1-git-send-email-lenb@kernel.org>
References: <1348374851-20378-1-git-send-email-lenb@kernel.org>
In-Reply-To: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1348371388.git.len.brown@intel.com>
References: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1348371388.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

This is unchanged version 20071116, plus a small bit in
DEFINE_ALTERNATE_TYPES to enable building with latest kernel headers.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 tools/power/acpi/acpidump.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/power/acpi/acpidump.c b/tools/power/acpi/acpidump.c
index 8e5e194..a63dee9 100644
--- a/tools/power/acpi/acpidump.c
+++ b/tools/power/acpi/acpidump.c
@@ -540,8 +540,11 @@ int main(int argc, char **argv)
 	if (connect) {
 		lseek(fd, sizeof(struct acpi_rsdp_descriptor), SEEK_SET);
 	}
-	if (!acpi_dump_XSDT(fd, &rsdpx))
-		goto not_found;
+	if (rsdpx.revision > 1 && rsdpx.xsdt_physical_address) {
+		/* ACPIDUMP uses xsdt table */
+		if (!acpi_dump_XSDT(fd, &rsdpx))
+			goto not_found;
+	}
 	if (!acpi_dump_RSDT(fd, &rsdpx))
 		goto not_found;
 	if (connect) {
-- 
1.7.12.1.396.g16eed7c

