Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab2HGRsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:48:55 -0400
Received: from mail.x86-64.org ([217.9.48.20]:35584 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755275Ab2HGRo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:44:27 -0400
From: Borislav Petkov <bp@amd64.org>
To: X86-ML <x86@kernel.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH v0 06/12] x86, microcode, AMD: Remove useless get_ucode_data wrapper
Date: Tue,  7 Aug 2012 19:44:15 +0200
Message-Id: <1344361461-10076-7-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
In-Reply-To: <1344361461-10076-1-git-send-email-bp@amd64.org>
References: <1344361461-10076-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

get_ucode_data was a trivial memcpy wrapper. Remove it so as not to
obfuscate code unnecessarily with no obvious gain.

No functional change.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/microcode.h | 6 ------
 arch/x86/kernel/microcode_amd.c  | 4 ++--
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index 4ebe157bf73d..8813be600995 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -49,12 +49,6 @@ static inline struct microcode_ops * __init init_intel_microcode(void)
 #ifdef CONFIG_MICROCODE_AMD
 extern struct microcode_ops * __init init_amd_microcode(void);
 extern void __exit exit_amd_microcode(void);
-
-static inline void get_ucode_data(void *to, const u8 *from, size_t n)
-{
-	memcpy(to, from, n);
-}
-
 #else
 static inline struct microcode_ops * __init init_amd_microcode(void)
 {
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 82746f942cd8..94213387a3d1 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -183,7 +183,7 @@ static int get_matching_microcode(int cpu, const u8 *ucode_ptr,
 	memset(patch, 0, PAGE_SIZE);
 
 	/* all looks ok, get the binary patch */
-	get_ucode_data(patch, ucode_ptr + SECTION_HDR_SIZE, actual_size);
+	memcpy(patch, ucode_ptr + SECTION_HDR_SIZE, actual_size);
 
 	return actual_size;
 }
@@ -238,7 +238,7 @@ static int install_equiv_cpu_table(const u8 *buf)
 		return -ENOMEM;
 	}
 
-	get_ucode_data(equiv_cpu_table, buf + CONTAINER_HDR_SZ, size);
+	memcpy(equiv_cpu_table, buf + CONTAINER_HDR_SZ, size);
 
 	/* add header length */
 	return size + CONTAINER_HDR_SZ;
-- 
1.7.11.rc1

