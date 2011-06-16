Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab1FPHL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:11:26 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:43239 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757039Ab1FPHLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:11:19 -0400
X-Sasl-enc: acQcCDqJGmSnYck+6Qlm8MOeIWdJwcuNzEyYfotQLl3s 1308208277
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:10 2011
Message-Id: <20110616002910.569916638@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:29:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [67/85] x86/amd-iommu: Fix 3 possible endless loops
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit 0de66d5b35ee148455e268b2782873204ffdef4b upstream.

The driver contains several loops counting on an u16 value
where the exit-condition is checked against variables that
can have values up to 0xffff. In this case the loops will
never exit. This patch fixed 3 such loops.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/amd_iommu_init.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -646,8 +646,8 @@ static void __init init_iommu_from_acpi(
 {
 	u8 *p = (u8 *)h;
 	u8 *end = p, flags = 0;
-	u16 dev_i, devid = 0, devid_start = 0, devid_to = 0;
-	u32 ext_flags = 0;
+	u16 devid = 0, devid_start = 0, devid_to = 0;
+	u32 dev_i, ext_flags = 0;
 	bool alias = false;
 	struct ivhd_entry *e;
 
@@ -802,7 +802,7 @@ static void __init init_iommu_from_acpi(
 /* Initializes the device->iommu mapping for the driver */
 static int __init init_iommu_devices(struct amd_iommu *iommu)
 {
-	u16 i;
+	u32 i;
 
 	for (i = iommu->first_device; i <= iommu->last_device; ++i)
 		set_iommu_for_device(iommu, i);
@@ -1088,7 +1088,7 @@ static int __init init_memory_definition
  */
 static void init_device_table(void)
 {
-	u16 devid;
+	u32 devid;
 
 	for (devid = 0; devid <= amd_iommu_last_bdf; ++devid) {
 		set_dev_entry_bit(devid, DEV_ENTRY_VALID);


