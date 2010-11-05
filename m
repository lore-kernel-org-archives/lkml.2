Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab0KEDIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:08:37 -0400
Received: from mail.perches.com ([173.55.12.10]:4020 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349Ab0KEDIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:08:34 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/49] arch/ia64: Use vzalloc
Date: Thu,  4 Nov 2010 20:07:25 -0700
Message-Id: <6c301491890dd0892a7e1a93bf1495f2131413f9.1288925424.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
In-Reply-To: <cover.1288925424.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/ia64/kernel/perfmon.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index 39e534f..3aee09d 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -829,10 +829,9 @@ pfm_rvmalloc(unsigned long size)
 	unsigned long addr;
 
 	size = PAGE_ALIGN(size);
-	mem  = vmalloc(size);
+	mem  = vzalloc(size);
 	if (mem) {
 		//printk("perfmon: CPU%d pfm_rvmalloc(%ld)=%p\n", smp_processor_id(), size, mem);
-		memset(mem, 0, size);
 		addr = (unsigned long)mem;
 		while (size > 0) {
 			pfm_reserve_page(addr);
-- 
1.7.3.1.g432b3.dirty

