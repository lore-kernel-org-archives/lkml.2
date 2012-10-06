Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab2JFUUJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 16:20:09 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:57076 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab2JFUUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 16:20:04 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 34/49] tools/power/acpi/acpidump: version 20071116
Date: Sat,  6 Oct 2012 16:09:55 -0400
Message-Id: <39a55ff2c34a11ab9bbc8ba6f4dfb5d366cb2532.1349554106.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <1349554210-29978-1-git-send-email-lenb@kernel.org>
References: <1349554210-29978-1-git-send-email-lenb@kernel.org>
In-Reply-To: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
References: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
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
1.8.0.rc0.18.gf84667d

