Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab2EHOFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 10:05:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:36026 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755688Ab2EHOFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 10:05:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="140343556"
From: Alex Shi <alex.shi@intel.com>
To: mgorman@suse.de, npiggin@gmail.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com
Cc: jeremy@goop.org, gregkh@linuxfoundation.org, glommer@redhat.com,
        riel@redhat.com, luto@mit.edu, alex.shi@intel.com, avi@redhat.com,
        len.brown@intel.com, dhowells@redhat.com, fenghua.yu@intel.com,
        borislav.petkov@amd.com, yinghai@kernel.org, ak@linux.intel.com,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        paul.gortmaker@windriver.com, trenn@suse.de, tj@kernel.org,
        oleg@redhat.com, axboe@kernel.dk, a.p.zijlstra@chello.nl,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/7] x86/tlb: remove comments for tlb_flush_range implement suggestion
Date: Tue,  8 May 2012 22:03:08 +0800
Message-Id: <1336485790-30902-6-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1336485790-30902-1-git-send-email-alex.shi@intel.com>
References: <1336485790-30902-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to this comments that inspired me using invlpg to replace cr3
rewrite.
Now, it is time to remove from code to avoid reader confusing.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 arch/x86/include/asm/tlbflush.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index ec30dfb..51f8b1c 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -81,10 +81,6 @@ static inline void __flush_tlb_one(unsigned long addr)
  *
  * ..but the i386 has somewhat limited tlb flushing capabilities,
  * and page-granular flushes are available only on i486 and up.
- *
- * x86-64 can only flush individual pages or full VMs. For a range flush
- * we always do the full VM. Might be worth trying if for a small
- * range a few INVLPGs in a row are a win.
  */
 
 #ifndef CONFIG_SMP
-- 
1.7.5.4

