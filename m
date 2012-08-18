Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab2HRRcw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 13:32:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:9940 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016Ab2HRRae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 13:30:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,791,1336374000"; 
   d="scan'208";a="210330070"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 27/31] sections: Fix section conflicts in mm/percpu
Date: Sat, 18 Aug 2012 10:30:18 -0700
Message-Id: <1345311022-26328-28-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/percpu.h |    2 +-
 mm/percpu.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 2b9f82c..cc88172 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -107,7 +107,7 @@ enum pcpu_fc {
 
 	PCPU_FC_NR,
 };
-extern const char *pcpu_fc_names[PCPU_FC_NR];
+extern const char * const pcpu_fc_names[PCPU_FC_NR];
 
 extern enum pcpu_fc pcpu_chosen_fc;
 
diff --git a/mm/percpu.c b/mm/percpu.c
index bb4be74..ddc5efb 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1370,7 +1370,7 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 
 #ifdef CONFIG_SMP
 
-const char *pcpu_fc_names[PCPU_FC_NR] __initdata = {
+const char * const pcpu_fc_names[PCPU_FC_NR] __initconst = {
 	[PCPU_FC_AUTO]	= "auto",
 	[PCPU_FC_EMBED]	= "embed",
 	[PCPU_FC_PAGE]	= "page",
-- 
1.7.7.6

