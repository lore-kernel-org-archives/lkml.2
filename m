Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab0ESVxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 17:53:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:41536 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038Ab0ESVxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 17:53:08 -0400
Date: Wed, 19 May 2010 21:52:52 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, jacob.jun.pan@linux.intel.com, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@linux.intel.com, jacob.jun.pan@linux.intel.com
In-Reply-To: <1274295685-6774-4-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1274295685-6774-4-git-send-email-jacob.jun.pan@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86, mrst: make mrst_timer_options an enum
Message-ID: <tip-14671386dcbafb3086bbda3cb6f9f27d34c7bf6d@git.kernel.org>
Git-Commit-ID: 14671386dcbafb3086bbda3cb6f9f27d34c7bf6d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 19 May 2010 21:52:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  14671386dcbafb3086bbda3cb6f9f27d34c7bf6d
Gitweb:     http://git.kernel.org/tip/14671386dcbafb3086bbda3cb6f9f27d34c7bf6d
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 19 May 2010 14:37:40 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 19 May 2010 14:37:40 -0700

x86, mrst: make mrst_timer_options an enum

We have an enum mrst_timer_options, use it so that the kernel knows if
we're missing something from a switch statement or equivalent.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
LKML-Reference: <1274295685-6774-4-git-send-email-jacob.jun.pan@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/include/asm/mrst.h |    3 ++-
 arch/x86/kernel/mrst.c      |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/mrst.h b/arch/x86/include/asm/mrst.h
index 1869c18..1635074 100644
--- a/arch/x86/include/asm/mrst.h
+++ b/arch/x86/include/asm/mrst.h
@@ -11,7 +11,6 @@
 #ifndef _ASM_X86_MRST_H
 #define _ASM_X86_MRST_H
 extern int pci_mrst_init(void);
-extern int mrst_timer_options __cpuinitdata;
 int __init sfi_parse_mrtc(struct sfi_table_header *table);
 
 /*
@@ -38,6 +37,8 @@ enum mrst_timer_options {
 	MRST_TIMER_LAPIC_APBT,
 };
 
+extern enum mrst_timer_options mrst_timer_options;
+
 #define SFI_MTMR_MAX_NUM 8
 #define SFI_MRTC_MAX	8
 
diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
index 967f268..7ee4ed9 100644
--- a/arch/x86/kernel/mrst.c
+++ b/arch/x86/kernel/mrst.c
@@ -46,7 +46,7 @@
  * lapic (always-on,ARAT) ------ 150
  */
 
-int mrst_timer_options __cpuinitdata;
+__cpuinitdata enum mrst_timer_options mrst_timer_options;
 
 static u32 sfi_mtimer_usage[SFI_MTMR_MAX_NUM];
 static struct sfi_timer_table_entry sfi_mtimer_array[SFI_MTMR_MAX_NUM];
