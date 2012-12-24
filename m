Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab2LXCOs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 21:14:48 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36442 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab2LXCOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 21:14:41 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 04/29] x86: rename random32() to prandom_u32()
Date: Mon, 24 Dec 2012 11:13:51 +0900
Message-Id: <1356315256-6572-5-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1356315256-6572-1-git-send-email-akinobu.mita@gmail.com>
References: <1356315256-6572-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
---
 arch/x86/mm/pageattr-test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pageattr-test.c b/arch/x86/mm/pageattr-test.c
index 8b8c381..9346108 100644
--- a/arch/x86/mm/pageattr-test.c
+++ b/arch/x86/mm/pageattr-test.c
@@ -132,10 +132,10 @@ static int pageattr_test(void)
 	failed += print_split(&sa);
 
 	for (i = 0; i < NTEST; i++) {
-		unsigned long pfn = random32() % max_pfn_mapped;
+		unsigned long pfn = prandom_u32() % max_pfn_mapped;
 
 		addr[i] = (unsigned long)__va(pfn << PAGE_SHIFT);
-		len[i] = random32() % 100;
+		len[i] = prandom_u32() % 100;
 		len[i] = min_t(unsigned long, len[i], max_pfn_mapped - pfn - 1);
 
 		if (len[i] == 0)
-- 
1.7.11.7

