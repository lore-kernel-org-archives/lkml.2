Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab2JOLpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 07:45:09 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:34280 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab2JOLpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 07:45:07 -0400
Date: Mon, 15 Oct 2012 13:44:56 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-mips@linux-mips.org,
        David Daney <david.daney@cavium.com>
Subject: [PATCH] mm: huge_memory: Fix build error.
Message-ID: <20121015114456.GA30314@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain configurations won't implicitly pull in <linux/pagemap.h> resulting
in the following build error:

mm/huge_memory.c: In function 'release_pte_page':
mm/huge_memory.c:1697:2: error: implicit declaration of function 'unlock_page' [-Werror=implicit-function-declaration]
mm/huge_memory.c: In function '__collapse_huge_page_isolate':
mm/huge_memory.c:1757:3: error: implicit declaration of function 'trylock_page' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

Reported-by: David Daney <david.daney@cavium.com>
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
---
 mm/huge_memory.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index f0e5306..b5d4eb8 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -17,6 +17,7 @@
 #include <linux/khugepaged.h>
 #include <linux/freezer.h>
 #include <linux/mman.h>
+#include <linux/pagemap.h>
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
 #include "internal.h"
