Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab2HSDAJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:00:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:42975 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511Ab2HSC50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="182675621"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 10/74] sections: Add __visible to drivers/{base,pci} sections
Date: Sat, 18 Aug 2012 19:56:06 -0700
Message-Id: <1345345030-22211-11-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/base/firmware_class.c |    4 ++--
 drivers/base/power/trace.c    |    2 +-
 drivers/pci/quirks.c          |   28 ++++++++++++++--------------
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 803cfc1..618ca735 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -30,8 +30,8 @@ MODULE_LICENSE("GPL");
 
 #ifdef CONFIG_FW_LOADER
 
-extern struct builtin_fw __start_builtin_fw[];
-extern struct builtin_fw __end_builtin_fw[];
+extern __visible struct builtin_fw __start_builtin_fw[];
+extern __visible struct builtin_fw __end_builtin_fw[];
 
 static bool fw_get_builtin_firmware(struct firmware *fw, const char *name)
 {
diff --git a/drivers/base/power/trace.c b/drivers/base/power/trace.c
index d94a1f5..3048afa 100644
--- a/drivers/base/power/trace.c
+++ b/drivers/base/power/trace.c
@@ -166,7 +166,7 @@ void generate_resume_trace(const void *tracedata, unsigned int user)
 }
 EXPORT_SYMBOL(generate_resume_trace);
 
-extern char __tracedata_start, __tracedata_end;
+extern __visible char __tracedata_start, __tracedata_end;
 static int show_file_hash(unsigned int value)
 {
 	int match;
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 5155317..d18ea93 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2941,20 +2941,20 @@ static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 		}
 }
 
-extern struct pci_fixup __start_pci_fixups_early[];
-extern struct pci_fixup __end_pci_fixups_early[];
-extern struct pci_fixup __start_pci_fixups_header[];
-extern struct pci_fixup __end_pci_fixups_header[];
-extern struct pci_fixup __start_pci_fixups_final[];
-extern struct pci_fixup __end_pci_fixups_final[];
-extern struct pci_fixup __start_pci_fixups_enable[];
-extern struct pci_fixup __end_pci_fixups_enable[];
-extern struct pci_fixup __start_pci_fixups_resume[];
-extern struct pci_fixup __end_pci_fixups_resume[];
-extern struct pci_fixup __start_pci_fixups_resume_early[];
-extern struct pci_fixup __end_pci_fixups_resume_early[];
-extern struct pci_fixup __start_pci_fixups_suspend[];
-extern struct pci_fixup __end_pci_fixups_suspend[];
+extern __visible struct pci_fixup __start_pci_fixups_early[];
+extern __visible struct pci_fixup __end_pci_fixups_early[];
+extern __visible struct pci_fixup __start_pci_fixups_header[];
+extern __visible struct pci_fixup __end_pci_fixups_header[];
+extern __visible struct pci_fixup __start_pci_fixups_final[];
+extern __visible struct pci_fixup __end_pci_fixups_final[];
+extern __visible struct pci_fixup __start_pci_fixups_enable[];
+extern __visible struct pci_fixup __end_pci_fixups_enable[];
+extern __visible struct pci_fixup __start_pci_fixups_resume[];
+extern __visible struct pci_fixup __end_pci_fixups_resume[];
+extern __visible struct pci_fixup __start_pci_fixups_resume_early[];
+extern __visible struct pci_fixup __end_pci_fixups_resume_early[];
+extern __visible struct pci_fixup __start_pci_fixups_suspend[];
+extern __visible struct pci_fixup __end_pci_fixups_suspend[];
 
 static bool pci_apply_fixup_final_quirks;
 
-- 
1.7.7.6

