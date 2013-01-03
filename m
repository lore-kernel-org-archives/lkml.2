Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab3ACMTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 07:19:55 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:52277 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab3ACMTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 07:19:45 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH -v2 03/26] x86: pageattr-test: remove srandom32 call
Date: Thu,  3 Jan 2013 21:18:59 +0900
Message-Id: <1357215562-6288-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
References: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pageattr-test calls srandom32() once every test iteration.
But calling srandom32() after late_initcalls is not meaningfull.
Because the random states for random32() is mixed by good random numbers
in late_initcall prandom_reseed().

So this removes the call to srandom32().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
---

No change from v1

 arch/x86/mm/pageattr-test.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/mm/pageattr-test.c b/arch/x86/mm/pageattr-test.c
index b008656..8b8c381 100644
--- a/arch/x86/mm/pageattr-test.c
+++ b/arch/x86/mm/pageattr-test.c
@@ -130,7 +130,6 @@ static int pageattr_test(void)
 	}
 
 	failed += print_split(&sa);
-	srandom32(100);
 
 	for (i = 0; i < NTEST; i++) {
 		unsigned long pfn = random32() % max_pfn_mapped;
-- 
1.7.11.7

