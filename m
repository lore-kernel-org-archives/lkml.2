Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965712Ab2EOCSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:18:46 -0400
Received: from mail.windriver.com ([147.11.1.11]:49381 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964914Ab2EOCQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:46 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 057/179] x86/amd-iommu: Fix 3 possible endless loops
Date: Mon, 14 May 2012 22:12:33 -0400
Message-ID: <1337048075-6132-58-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 0de66d5b35ee148455e268b2782873204ffdef4b upstream.

The driver contains several loops counting on an u16 value
where the exit-condition is checked against variables that
can have values up to 0xffff. In this case the loops will
never exit. This patch fixed 3 such loops.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/amd_iommu_init.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index fa749f7..82571af 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -649,8 +649,8 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 {
 	u8 *p = (u8 *)h;
 	u8 *end = p, flags = 0;
-	u16 dev_i, devid = 0, devid_start = 0, devid_to = 0;
-	u32 ext_flags = 0;
+	u16 devid = 0, devid_start = 0, devid_to = 0;
+	u32 dev_i, ext_flags = 0;
 	bool alias = false;
 	struct ivhd_entry *e;
 
@@ -805,7 +805,7 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 /* Initializes the device->iommu mapping for the driver */
 static int __init init_iommu_devices(struct amd_iommu *iommu)
 {
-	u16 i;
+	u32 i;
 
 	for (i = iommu->first_device; i <= iommu->last_device; ++i)
 		set_iommu_for_device(iommu, i);
@@ -1094,7 +1094,7 @@ static int __init init_memory_definitions(struct acpi_table_header *table)
  */
 static void init_device_table(void)
 {
-	u16 devid;
+	u32 devid;
 
 	for (devid = 0; devid <= amd_iommu_last_bdf; ++devid) {
 		set_dev_entry_bit(devid, DEV_ENTRY_VALID);
-- 
1.7.9.6

