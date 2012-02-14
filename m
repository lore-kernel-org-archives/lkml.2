Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487Ab2BNAJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 19:09:52 -0500
Received: from mail-ee0-f74.google.com ([74.125.83.74]:58718 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab2BNAJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 19:09:51 -0500
Subject: [PATCH] ACPI / PM: print physical addresses consistently with other
	parts of kernel
To: Len Brown <lenb@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 13 Feb 2012 17:04:43 -0700
Message-ID: <20120214000443.32491.31655.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print physical address info in a style consistent with the %pR style used
elsewhere in the kernel.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/acpi/nvs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/nvs.c b/drivers/acpi/nvs.c
index 7a2035f..266bc58 100644
--- a/drivers/acpi/nvs.c
+++ b/drivers/acpi/nvs.c
@@ -95,8 +95,8 @@ static int suspend_nvs_register(unsigned long start, unsigned long size)
 {
 	struct nvs_page *entry, *next;
 
-	pr_info("PM: Registering ACPI NVS region at %lx (%ld bytes)\n",
-		start, size);
+	pr_info("PM: Registering ACPI NVS region [mem %#010lx-%#010lx] (%ld bytes)\n",
+		start, start + size - 1, size);
 
 	while (size > 0) {
 		unsigned int nr_bytes;

