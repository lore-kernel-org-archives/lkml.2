Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab0E0Mcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 08:32:53 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:51744 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab0E0Mcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 08:32:50 -0400
Date: Thu, 27 May 2010 14:32:45 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: "David S. Miller" <davem@davemloft.net>,
       Grant Likely <grant.likely@secretlab.ca>, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 3/11] arch/sparc/kernel: Eliminate what looks like a NULL
 pointer dereference
Message-ID: <Pine.LNX.4.64.1005271432250.5422@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

At the point of the test, action cannot be NULL, as it has been dereferenced
in the code just above.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E,E1;
identifier f;
statement S1,S2,S3;
@@

if ((E == NULL && ...) || ...)
{
  ... when != if (...) S1 else S2
      when != E = E1
* E->f
  ... when any
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/sparc/kernel/sun4d_irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/sun4d_irq.c b/arch/sparc/kernel/sun4d_irq.c
index ab036a7..e11b461 100644
--- a/arch/sparc/kernel/sun4d_irq.c
+++ b/arch/sparc/kernel/sun4d_irq.c
@@ -183,7 +183,7 @@ void sun4d_free_irq(unsigned int irq, void *dev_id)
 		goto out_unlock;
 	}
 	
-	if (action && tmp)
+	if (tmp)
 		tmp->next = action->next;
 	else
 		*actionp = action->next;
