Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab2BIKaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 05:30:21 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42309 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757745Ab2BIKaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 05:30:20 -0500
Date: Thu, 9 Feb 2012 11:30:16 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, mingo@elte.hu
Subject: [PATCH] perf: add sanity check on addr in symbol__inc_addr_samples()
Message-ID: <20120209103016.GA1999@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Check the value of addr against the bounds of the symbol.
This is needed given we compute an offset:
    	offset = addr - sym->start
    
And we don't want the offset to become negative.
    
Signed-off-by: Stephane Eranian <eranian@google.com>

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 011ed26..8248d80 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -64,7 +64,7 @@ int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 
 	pr_debug3("%s: addr=%#" PRIx64 "\n", __func__, map->unmap_ip(map, addr));
 
-	if (addr >= sym->end)
+	if (addr >= sym->end || addr < sym->start)
 		return 0;
 
 	offset = addr - sym->start;
