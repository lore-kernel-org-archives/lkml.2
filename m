Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab2HSDCA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:02:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:1635 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864Ab2HSC5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="210415464"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Joe Mario <jmario@redhat.com>, ananth@in.ibm.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 71/74] lto, kprobes: Use KSYM_NAME_LEN to size identifier buffers
Date: Sat, 18 Aug 2012 19:57:07 -0700
Message-Id: <1345345030-22211-72-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Mario <jmario@redhat.com>

Use KSYM_NAME_LEN to size identifier buffers, so that it can
be easier increased.

Cc: ananth@in.ibm.com
Signed-off-by: Joe Mario <jmario@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/kprobes.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index c62b854..b9bd2a8 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1955,7 +1955,7 @@ static int __init init_kprobes(void)
 {
 	int i, err = 0;
 	unsigned long offset = 0, size = 0;
-	char *modname, namebuf[128];
+	char *modname, namebuf[KSYM_NAME_LEN];
 	const char *symbol_name;
 	void *addr;
 	struct kprobe_blackpoint *kb;
@@ -2081,7 +2081,7 @@ static int __kprobes show_kprobe_addr(struct seq_file *pi, void *v)
 	const char *sym = NULL;
 	unsigned int i = *(loff_t *) v;
 	unsigned long offset = 0;
-	char *modname, namebuf[128];
+	char *modname, namebuf[KSYM_NAME_LEN];
 
 	head = &kprobe_table[i];
 	preempt_disable();
-- 
1.7.7.6

