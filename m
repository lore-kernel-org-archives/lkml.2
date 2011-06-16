Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab1FPLS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 07:18:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:45191 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248Ab1FPLSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:18:23 -0400
Date: Thu, 16 Jun 2011 11:18:14 GMT
From: tip-bot for Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Message-ID: <tip-2b90e77eaee8809073db5cf43ac9795cc2054dc0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        seto.hidetoshi@jp.fujitsu.com, tony.luck@intel.com, tglx@linutronix.de,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de, tony.luck@intel.com,
        borislav.petkov@amd.com
In-Reply-To: <4DEED6E8.9090509@jp.fujitsu.com>
References: <4DEED6E8.9090509@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:ras/core] x86, mce: Replace MCM_ with MCI_MISC_
Git-Commit-ID: 2b90e77eaee8809073db5cf43ac9795cc2054dc0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Jun 2011 11:18:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2b90e77eaee8809073db5cf43ac9795cc2054dc0
Gitweb:     http://git.kernel.org/tip/2b90e77eaee8809073db5cf43ac9795cc2054dc0
Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
AuthorDate: Wed, 8 Jun 2011 10:56:56 +0900
Committer:  Borislav Petkov <borislav.petkov@amd.com>
CommitDate: Thu, 16 Jun 2011 12:10:10 +0200

x86, mce: Replace MCM_ with MCI_MISC_

Follow other MCi register defines. Plus define MCI_MISC_ADDR_LSB() and
MCI_MISC_ADDR_MODE().

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Acked-by: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/4DEED6E8.9090509@jp.fujitsu.com
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/mce.h       |   17 +++++++++++------
 arch/x86/kernel/cpu/mcheck/mce.c |    4 ++--
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 021979a..bbb328f 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -8,6 +8,7 @@
  * Machine Check support for x86
  */
 
+/* MCG_CAP register defines */
 #define MCG_BANKCNT_MASK	0xff         /* Number of Banks */
 #define MCG_CTL_P		(1ULL<<8)    /* MCG_CTL register available */
 #define MCG_EXT_P		(1ULL<<9)    /* Extended registers available */
@@ -17,10 +18,12 @@
 #define MCG_EXT_CNT(c)		(((c) & MCG_EXT_CNT_MASK) >> MCG_EXT_CNT_SHIFT)
 #define MCG_SER_P	 	(1ULL<<24)   /* MCA recovery/new status bits */
 
+/* MCG_STATUS register defines */
 #define MCG_STATUS_RIPV  (1ULL<<0)   /* restart ip valid */
 #define MCG_STATUS_EIPV  (1ULL<<1)   /* ip points to correct instruction */
 #define MCG_STATUS_MCIP  (1ULL<<2)   /* machine check in progress */
 
+/* MCi_STATUS register defines */
 #define MCI_STATUS_VAL   (1ULL<<63)  /* valid error */
 #define MCI_STATUS_OVER  (1ULL<<62)  /* previous errors lost */
 #define MCI_STATUS_UC    (1ULL<<61)  /* uncorrected error */
@@ -31,12 +34,14 @@
 #define MCI_STATUS_S	 (1ULL<<56)  /* Signaled machine check */
 #define MCI_STATUS_AR	 (1ULL<<55)  /* Action required */
 
-/* MISC register defines */
-#define MCM_ADDR_SEGOFF  0	/* segment offset */
-#define MCM_ADDR_LINEAR  1	/* linear address */
-#define MCM_ADDR_PHYS	 2	/* physical address */
-#define MCM_ADDR_MEM	 3	/* memory address */
-#define MCM_ADDR_GENERIC 7	/* generic */
+/* MCi_MISC register defines */
+#define MCI_MISC_ADDR_LSB(m)	((m) & 0x3f)
+#define MCI_MISC_ADDR_MODE(m)	(((m) >> 6) & 7)
+#define  MCI_MISC_ADDR_SEGOFF	0	/* segment offset */
+#define  MCI_MISC_ADDR_LINEAR	1	/* linear address */
+#define  MCI_MISC_ADDR_PHYS	2	/* physical address */
+#define  MCI_MISC_ADDR_MEM	3	/* memory address */
+#define  MCI_MISC_ADDR_GENERIC	7	/* generic */
 
 /* CTL2 register defines */
 #define MCI_CTL2_CMCI_EN		(1ULL << 30)
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index e81d48b..e807508 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -844,9 +844,9 @@ static int mce_usable_address(struct mce *m)
 {
 	if (!(m->status & MCI_STATUS_MISCV) || !(m->status & MCI_STATUS_ADDRV))
 		return 0;
-	if ((m->misc & 0x3f) > PAGE_SHIFT)
+	if (MCI_MISC_ADDR_LSB(m->misc) > PAGE_SHIFT)
 		return 0;
-	if (((m->misc >> 6) & 7) != MCM_ADDR_PHYS)
+	if (MCI_MISC_ADDR_MODE(m->misc) != MCI_MISC_ADDR_PHYS)
 		return 0;
 	return 1;
 }
