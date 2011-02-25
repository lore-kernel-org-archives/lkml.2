Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab1BYEGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 23:06:37 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:47102 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186Ab1BYEGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 23:06:36 -0500
Date: Thu, 24 Feb 2011 20:06:31 -0800
From: Andres Salomon <dilinger@queued.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH] x86: OLPC: have prom_early_alloc BUG rather than return
 NULL
Message-ID: <20110224200631.0007833e@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


..similar to what sparc's prom_early_alloc does.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/x86/platform/olpc/olpc_dt.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/olpc/olpc_dt.c b/arch/x86/platform/olpc/olpc_dt.c
index dab8746..044bda5 100644
--- a/arch/x86/platform/olpc/olpc_dt.c
+++ b/arch/x86/platform/olpc/olpc_dt.c
@@ -140,8 +140,7 @@ void * __init prom_early_alloc(unsigned long size)
 		 * wasted bootmem) and hand off chunks of it to callers.
 		 */
 		res = alloc_bootmem(chunk_size);
-		if (!res)
-			return NULL;
+		BUG_ON(!res);
 		prom_early_allocated += chunk_size;
 		memset(res, 0, chunk_size);
 		free_mem = chunk_size;
-- 
1.7.2.3

