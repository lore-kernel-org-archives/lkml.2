Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab2HSDB3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:01:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:44069 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770Ab2HSC5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="210415463"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Joe Mario <jmario@redhat.com>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 69/74] lto: Increase kallsyms max symbol length
Date: Sat, 18 Aug 2012 19:57:05 -0700
Message-Id: <1345345030-22211-70-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Mario <jmario@redhat.com>

With the added postfixes that LTO adds for local
symbols, the longest name in the kernel overflows
the namebuf[KSYM_NAME_LEN] array by two bytes.  That name is:
__pci_fixup_resumePCI_VENDOR_ID_SERVERWORKSPCI_DEVICE_ID_SERVERWORKS_HT1000SBquirk_disable_broadcom_boot_interrupt.1488004.672802

Double the max symbol name length.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/kallsyms.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index 6883e19..711a50f 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -9,7 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/stddef.h>
 
-#define KSYM_NAME_LEN 128
+#define KSYM_NAME_LEN 256
 #define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s]") + (KSYM_NAME_LEN - 1) + \
 			 2*(BITS_PER_LONG*3/10) + (MODULE_NAME_LEN - 1) + 1)
 
-- 
1.7.7.6

