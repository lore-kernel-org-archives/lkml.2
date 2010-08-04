Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab0HDETw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 00:19:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:60067 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628Ab0HDETv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 00:19:51 -0400
Subject: [PATCH] memblock: Fix memblock_is_region_reserved() to return a
 boolean
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 14:19:31 +1000
Message-ID: <1280895571.1902.140.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All callers expect a boolean result which is true if the region
overlaps a reserved region. However, the implementation actually
returns -1 if there is no overlap, and a region index (0 based)
if there is.

Make it behave as callers (and common sense) expect.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Taking that out of my memblock rework branch as it should go in
now regardless of whether my stuff goes or not (which is still
under discussion, I'm fixing ARM up now).

I'll send this fix to Linus tomorrow along with powerpc.git if there
is no adverse comment.

diff --git a/mm/memblock.c b/mm/memblock.c
index 3024eb3..43840b3 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -504,7 +504,7 @@ int __init memblock_is_reserved(u64 addr)
 
 int memblock_is_region_reserved(u64 base, u64 size)
 {
-	return memblock_overlaps_region(&memblock.reserved, base, size);
+	return memblock_overlaps_region(&memblock.reserved, base, size) >= 0;
 }
 
 /*


