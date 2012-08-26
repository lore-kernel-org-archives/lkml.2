Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab2HZISm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 04:18:42 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:5463 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751027Ab2HZISk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 04:18:40 -0400
X-IronPort-AV: E=Sophos;i="4.80,315,1344204000"; 
   d="scan'208";a="170834359"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] tools/power/x86/turbostat/turbostat.c: delete double assignment
Date: Sun, 26 Aug 2012 10:18:34 +0200
Message-Id: <1345969115-12977-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete successive assignments to the same location.
Change the second assignment to the corresponding size variable, analogous
to the code below.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression i;
@@

*i = ...;
 i = ...;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 tools/power/x86/turbostat/turbostat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 861d771..fc9b2b0 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -719,7 +719,7 @@ void free_all_buffers(void)
 {
 	CPU_FREE(cpu_present_set);
 	cpu_present_set = NULL;
-	cpu_present_set = 0;
+	cpu_present_setsize = 0;
 
 	CPU_FREE(cpu_affinity_set);
 	cpu_affinity_set = NULL;

