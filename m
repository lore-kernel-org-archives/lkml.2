Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab3ACMYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 07:24:10 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:47071 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab3ACMUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 07:20:08 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, lguest@lists.ozlabs.org
Subject: [PATCH -v2 15/26] lguest: rename random32() to prandom_u32()
Date: Thu,  3 Jan 2013 21:19:11 +0900
Message-Id: <1357215562-6288-16-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
References: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: lguest@lists.ozlabs.org
---

No change from v1

 drivers/lguest/page_tables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/lguest/page_tables.c b/drivers/lguest/page_tables.c
index 3b62be16..864baab 100644
--- a/drivers/lguest/page_tables.c
+++ b/drivers/lguest/page_tables.c
@@ -686,7 +686,7 @@ static unsigned int new_pgdir(struct lg_cpu *cpu,
 	 * We pick one entry at random to throw out.  Choosing the Least
 	 * Recently Used might be better, but this is easy.
 	 */
-	next = random32() % ARRAY_SIZE(cpu->lg->pgdirs);
+	next = prandom_u32() % ARRAY_SIZE(cpu->lg->pgdirs);
 	/* If it's never been allocated at all before, try now. */
 	if (!cpu->lg->pgdirs[next].pgdir) {
 		cpu->lg->pgdirs[next].pgdir =
-- 
1.7.11.7

