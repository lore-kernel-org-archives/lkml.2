Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab2KVUsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:48:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964860Ab2KVS6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:44 -0500
Date: Wed, 21 Nov 2012 17:42:36 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-28b6ff667013735dd2e68edd105d17cdf3835dcb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-6-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-6-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm: Revert back good_end setting for 64bit
Git-Commit-ID: 28b6ff667013735dd2e68edd105d17cdf3835dcb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 17:42:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  28b6ff667013735dd2e68edd105d17cdf3835dcb
Gitweb:     http://git.kernel.org/tip/28b6ff667013735dd2e68edd105d17cdf3835dcb
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:38:42 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:04 -0800

x86, mm: Revert back good_end setting for 64bit

After

| commit 8548c84da2f47e71bbbe300f55edb768492575f7
| Author: Takashi Iwai <tiwai@suse.de>
| Date:   Sun Oct 23 23:19:12 2011 +0200
|
|    x86: Fix S4 regression
|
|    Commit 4b239f458 ("x86-64, mm: Put early page table high") causes a S4
|    regression since 2.6.39, namely the machine reboots occasionally at S4
|    resume.  It doesn't happen always, overall rate is about 1/20.  But,
|    like other bugs, once when this happens, it continues to happen.
|
|    This patch fixes the problem by essentially reverting the memory
|    assignment in the older way.

Have some page table around 512M again, that will prevent kdump to find 512M
under 768M.

We need revert that reverting, so we could put page table high again for 64bit.

Takashi agreed that S4 regression could be something else.

	https://lkml.org/lkml/2012/6/15/182

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-6-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 9e17f9e..dbef4ff 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -234,8 +234,8 @@ static void __init find_early_table_space(struct map_range *mr, int nr_range)
 #ifdef CONFIG_X86_32
 	/* for fixmap */
 	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
-#endif
 	good_end = max_pfn_mapped << PAGE_SHIFT;
+#endif
 
 	base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
 	if (!base)
