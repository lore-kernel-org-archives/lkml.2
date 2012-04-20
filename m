Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab2DTWxE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 18:53:04 -0400
Received: from outmail019.snc4.facebook.com ([66.220.144.153]:48871 "EHLO
	intmgw001.snc4.facebook.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756381Ab2DTWxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 18:53:00 -0400
From: Arun Sharma <asharma@fb.com>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 4/4] x86: Check user address explicitly in copy_from_user_nmi()
Date: Fri, 20 Apr 2012 15:41:36 -0700
Message-Id: <1334961696-19580-5-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1334961696-19580-1-git-send-email-asharma@fb.com>
References: <1334961696-19580-1-git-send-email-asharma@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arun Sharma <asharma@fb.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/lib/usercopy.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
index d6ae30b..2da7914 100644
--- a/arch/x86/lib/usercopy.c
+++ b/arch/x86/lib/usercopy.c
@@ -21,6 +21,9 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 	void *map;
 	int ret;
 
+	if (__range_not_ok(from, n, TASK_SIZE) == 0)
+		return len;
+
 	do {
 		ret = __get_user_pages_fast(addr, 1, 0, &page);
 		if (!ret)
-- 
1.7.8.4

