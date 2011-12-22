Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab1LVQWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 11:22:09 -0500
Received: from border.exmeritus.com ([70.167.241.26]:32831 "EHLO
	border.exmeritus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab1LVQWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 11:22:07 -0500
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: Kyle Moffett <Kyle.D.Moffett@boeing.com>, Josh Boyer <jwboyer@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc/currituck: Fix up missing MPIC_PRIMARY flag
Date: Thu, 22 Dec 2011 11:21:21 -0500
Message-Id: <1324570881-11503-1-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 44x/currituck platform didn't get updated when the MPIC code
inverted the flag from MPIC_PRIMARY => !MPIC_SECONDARY.  Fix it up.

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 arch/powerpc/platforms/44x/currituck.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/44x/currituck.c b/arch/powerpc/platforms/44x/currituck.c
index 1fdf569..3f6229b 100644
--- a/arch/powerpc/platforms/44x/currituck.c
+++ b/arch/powerpc/platforms/44x/currituck.c
@@ -83,7 +83,7 @@ static void __init ppc47x_init_irq(void)
 		 * device-tree, just pass 0 to all arguments
 		 */
 		struct mpic *mpic =
-			mpic_alloc(np, 0, MPIC_PRIMARY, 0, 0, " MPIC     ");
+			mpic_alloc(np, 0, 0, 0, 0, " MPIC     ");
 		BUG_ON(mpic == NULL);
 		mpic_init(mpic);
 		ppc_md.get_irq = mpic_get_irq;
-- 
1.7.7.3

