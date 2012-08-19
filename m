Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab2HSDDL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:03:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:48688 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012Ab2HSC5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="182422083"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 70/74] Kbuild, lto: Handle longer symbols in kallsyms.c
Date: Sat, 18 Aug 2012 19:57:06 -0700
Message-Id: <1345345030-22211-71-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Also warn for too long symbols

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 scripts/kallsyms.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 487ac6f..acde016 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -27,7 +27,7 @@
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof(arr[0]))
 #endif
 
-#define KSYM_NAME_LEN		128
+#define KSYM_NAME_LEN		256
 
 struct sym_entry {
 	unsigned long long addr;
@@ -111,6 +111,12 @@ static int read_symbol(FILE *in, struct sym_entry *s)
 			fprintf(stderr, "Read error or end of file.\n");
 		return -1;
 	}
+	if (strlen(str) > KSYM_NAME_LEN) {
+		fprintf(stderr, "Symbol %s too long for kallsyms.\n"
+                                "Please increae KSYM_NAME_LEN both in kernel and kallsyms.c",
+			str);
+		return -1;
+	}
 
 	sym = str;
 	/* skip prefix char */
-- 
1.7.7.6

