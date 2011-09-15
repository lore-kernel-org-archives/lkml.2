Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934825Ab1IOUKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:10:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:48932 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934772Ab1IOUKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:10:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48873453"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, tj@kernel.org
Subject: [PATCH 25/27] Initconst section fixes for percpu
Date: Thu, 15 Sep 2011 13:09:52 -0700
Message-Id: <1316117394-21666-26-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Cc: tj@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/percpu.h |    2 +-
 mm/percpu.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 9ca008f..2b79f8f 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -107,7 +107,7 @@ enum pcpu_fc {
 
 	PCPU_FC_NR,
 };
-extern const char *pcpu_fc_names[PCPU_FC_NR];
+extern const char * const pcpu_fc_names[PCPU_FC_NR];
 
 extern enum pcpu_fc pcpu_chosen_fc;
 
diff --git a/mm/percpu.c b/mm/percpu.c
index bf80e55..15dd9a3 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1344,7 +1344,7 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 
 #ifdef CONFIG_SMP
 
-const char *pcpu_fc_names[PCPU_FC_NR] __initdata = {
+const char * const pcpu_fc_names[PCPU_FC_NR] __initconst = {
 	[PCPU_FC_AUTO]	= "auto",
 	[PCPU_FC_EMBED]	= "embed",
 	[PCPU_FC_PAGE]	= "page",
-- 
1.7.4.4

