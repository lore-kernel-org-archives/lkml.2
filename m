Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab0HZNZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 09:25:28 -0400
Received: from relay1.sgi.com ([192.48.179.29]:42271 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414Ab0HZNVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 09:21:24 -0400
Message-Id: <20100826132123.763139236@sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 26 Aug 2010 08:19:42 -0500
From: steiner@sgi.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [Patch 05/25] GRU - cbe cache flush
References: <20100826131937.108920216@sgi.com>
Content-Disposition: inline; filename=uv_gru_cbe_flush
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

In some cases, for performance reasons flushing the SGI GRU cbe
needs to dirty the cacheline before doing the cacheline flush. This ensures
that the dirty cacheline actually goes back to the caching home agent.
Update a reserved field in the CBE instead of a field that might be used. This
_should_ not be required (dirtying any field should be ok) but early
silicon has an issue here.

Note that flushing the CL is not a requirement - only a performance enhancement.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 drivers/misc/sgi-gru/grufault.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c	2010-06-09 08:11:40.285085853 -0500
+++ linux/drivers/misc/sgi-gru/grufault.c	2010-06-09 08:11:41.157110138 -0500
@@ -306,7 +306,7 @@ upm:
 static void gru_flush_cache_cbe(struct gru_control_block_extended *cbe)
 {
 	if (unlikely(cbe)) {
-		cbe->cbrexecstatus = 0;         /* make CL dirty */
+		cbe->reserved6 = 0;         /* make CL dirty */
 		gru_flush_cache(cbe);
 	}
 }

