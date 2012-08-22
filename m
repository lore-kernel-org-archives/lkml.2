Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792Ab2HVXli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 19:41:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47510 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029Ab2HVXld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 19:41:33 -0400
Date: Wed, 22 Aug 2012 16:41:21 -0700
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-e7e632f5ba240fbc313c49ed6559681ea57534e9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, borislav.petkov@amd.com
In-Reply-To: <1344361461-10076-7-git-send-email-bp@amd64.org>
References: <1344361461-10076-7-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, microcode, AMD:
  Remove useless get_ucode_data wrapper
Git-Commit-ID: e7e632f5ba240fbc313c49ed6559681ea57534e9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Aug 2012 16:41:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e7e632f5ba240fbc313c49ed6559681ea57534e9
Gitweb:     http://git.kernel.org/tip/e7e632f5ba240fbc313c49ed6559681ea57534e9
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Fri, 20 Jul 2012 14:12:21 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 22 Aug 2012 16:15:26 -0700

x86, microcode, AMD: Remove useless get_ucode_data wrapper

get_ucode_data was a trivial memcpy wrapper. Remove it so as not to
obfuscate code unnecessarily with no obvious gain.

No functional change.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/r/1344361461-10076-7-git-send-email-bp@amd64.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/microcode.h |    6 ------
 arch/x86/kernel/microcode_amd.c  |    4 ++--
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index 4ebe157..8813be6 100644
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
index 82746f9..9421338 100644
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
