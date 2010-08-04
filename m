Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab0HDCwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 22:52:16 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:39576 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758119Ab0HDCwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 22:52:08 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: K3fxw7MVM1ndL6fWpvaQ5ZKX4c5kopz.EKm82tgx7viDIKK
 j7o1ch0MTfBuxblq8F12QTqg6FUTFYpak5bljN3ilMG03OxlvjCGom3TcVQy
 qARIg5jfIeZZckWIxntsI4QK1YVsrvdCVagDs69_P6KWC2sp1rm9WVo.AbWX
 .ButJ2isAWo6pxEFpG5EjmG7GAdI8KXMWjTI0oyIndGZP8bCWAMHya5XGPNV
 XkuYdDLOmK.v4Oa0pp787aQUzP3NG5piFPA--
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20100804024526.723788302@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 Aug 2010 21:45:19 -0500
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: Nick Piggin <npiggin@suse.de>
Cc: David Rientjes <rientjes@google.com>
Subject: [S+Q3 05/23] Subjec Slub: Force no inlining of debug functions
References: <20100804024514.139976032@linux.com>
Content-Disposition: inline; filename=slub_nolinline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiler folds the debgging functions into the critical paths.
Avoid that by adding noinline to the functions that check for
problems.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-07-29 18:32:26.000000000 -0500
+++ linux-2.6/mm/slub.c	2010-07-29 18:32:33.000000000 -0500
@@ -857,7 +857,7 @@ static void setup_object_debug(struct km
 	init_tracking(s, object);
 }
 
-static int alloc_debug_processing(struct kmem_cache *s, struct page *page,
+static noinline int alloc_debug_processing(struct kmem_cache *s, struct page *page,
 					void *object, unsigned long addr)
 {
 	if (!check_slab(s, page))
@@ -897,8 +897,8 @@ bad:
 	return 0;
 }
 
-static int free_debug_processing(struct kmem_cache *s, struct page *page,
-					void *object, unsigned long addr)
+static noinline int free_debug_processing(struct kmem_cache *s,
+		 struct page *page, void *object, unsigned long addr)
 {
 	if (!check_slab(s, page))
 		goto fail;

