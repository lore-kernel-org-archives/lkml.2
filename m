Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab1HBKgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 06:36:54 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59123 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254Ab1HBKfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 06:35:17 -0400
From: Julia Lawall <julia@diku.dk>
To: Hirokazu Takata <takata@linux-m32r.org>, trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Chris Metcalf <cmetcalf@tilera.com>, linux-m32r@ml.linux-m32r.org,
        linux-m32r-ja@ml.linux-m32r.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/11] arch/m32r/kernel/smp.c: trivial: use BUG_ON
Date: Tue,  2 Aug 2011 12:35:00 +0200
Message-Id: <1312281304-11847-8-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1312281304-11847-1-git-send-email-julia@diku.dk>
References: <1312281304-11847-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use BUG_ON(x) rather than if(x) BUG();

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@ identifier x; @@
-if (x) BUG();
+BUG_ON(x);

@@ identifier x; @@
-if (!x) BUG();
+BUG_ON(!x);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/m32r/kernel/smp.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -u -p a/arch/m32r/kernel/smp.c b/arch/m32r/kernel/smp.c
--- a/arch/m32r/kernel/smp.c
+++ b/arch/m32r/kernel/smp.c
@@ -327,8 +327,7 @@ void smp_flush_tlb_page(struct vm_area_s
 	cpumask_clear_cpu(cpu_id, &cpu_mask);
 
 #ifdef DEBUG_SMP
-	if (!mm)
-		BUG();
+	BUG_ON(!mm);
 #endif
 
 	if (*mmc != NO_CONTEXT) {

