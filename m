Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab2KUA7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 19:59:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45725 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab2KUA7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 19:59:16 -0500
Date: Tue, 20 Nov 2012 16:58:44 -0800
From: tip-bot for Joonsoo Kim <js1304@gmail.com>
Message-ID: <tip-ddd32b4289a6feda9ad9e68b0d85641c389a72ba@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, js1304@gmail.com, hpa@zytor.com,
        mingo@kernel.org, alex.shi@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, js1304@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, alex.shi@intel.com,
        hpa@linux.intel.com
In-Reply-To: <1352740656-19417-1-git-send-email-js1304@gmail.com>
References: <1352740656-19417-1-git-send-email-js1304@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mm:
  Correct vmflag test for checking VM_HUGETLB
Git-Commit-ID: ddd32b4289a6feda9ad9e68b0d85641c389a72ba
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 20 Nov 2012 16:59:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ddd32b4289a6feda9ad9e68b0d85641c389a72ba
Gitweb:     http://git.kernel.org/tip/ddd32b4289a6feda9ad9e68b0d85641c389a72ba
Author:     Joonsoo Kim <js1304@gmail.com>
AuthorDate: Tue, 13 Nov 2012 02:17:36 +0900
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 14 Nov 2012 15:03:20 -0800

x86, mm: Correct vmflag test for checking VM_HUGETLB

commit 611ae8e3f5204f7480b3b405993b3352cfa16662('enable tlb flush range
support for x86') change flush_tlb_mm_range() considerably. After this,
we test whether vmflag equal to VM_HUGETLB and it may be always failed,
because vmflag usually has other flags simultaneously.
Our intention is to check whether this vma is for hughtlb, so correct it
according to this purpose.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Acked-by: Alex Shi <alex.shi@intel.com>
Link: http://lkml.kernel.org/r/1352740656-19417-1-git-send-email-js1304@gmail.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/tlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 0777f04..60f926c 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -197,7 +197,7 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 	}
 
 	if (end == TLB_FLUSH_ALL || tlb_flushall_shift == -1
-					|| vmflag == VM_HUGETLB) {
+					|| vmflag & VM_HUGETLB) {
 		local_flush_tlb();
 		goto flush_all;
 	}
