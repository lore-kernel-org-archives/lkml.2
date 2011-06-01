Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab1FAR04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:26:56 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:28823 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932115Ab1FAR0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:26:22 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 5uCvgT4VM1lmfzd4qza.wrA1E51hxVrQWjkrecI.d4oajVq
 RGZUpjPGtmGitP6GmwHMZyHSR18CzuoL_R3_KaUnB93RxvtJN.XRDR9v5xMa
 SpIvJR2ISPHOQZN_2VADM0sQl7xwW.9mzmZgn4jCii0mYb.6fCzhP7Ba9HF_
 QZmR3mMMCxeFeYXC6CExW76WSUnAu5O3ydV5coVPja6hc926FHmYaKodxybL
 7gnk4DRDc41_jywGmE0Z4xOfwF_NTDNRRwjVzmlTw6sNP1dhi5rc_IrF3gBW
 6h3NyxKJzyNHIirGNkSwP1_KAQYoJ44EuRCZlbj2QdEjnbHv3
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110601172620.978626828@linux.com>
User-Agent: quilt/0.48-1
Date: Wed, 01 Jun 2011 12:25:59 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv7 16/17] slub: Not necessary to check for empty slab on load_freelist
References: <20110601172543.437240675@linux.com>
Content-Disposition: inline; filename=goto_load_freelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

load_freelist is now only branched to only if there are objects available.
So no need to check the object variable for NULL.

---
 mm/slub.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-05-31 14:27:21.372880046 -0500
+++ linux-2.6/mm/slub.c	2011-05-31 14:27:25.262880020 -0500
@@ -1997,9 +1997,6 @@ static void *__slab_alloc(struct kmem_ca
 			NULL, new.counters,
 			"__slab_alloc"));
 
-load_freelist:
-	VM_BUG_ON(!page->frozen);
-
 	if (unlikely(!object)) {
 		c->page = NULL;
 		stat(s, DEACTIVATE_BYPASS);
@@ -2008,6 +2005,8 @@ load_freelist:
 
 	stat(s, ALLOC_REFILL);
 
+load_freelist:
+	VM_BUG_ON(!page->frozen);
 	c->freelist = get_freepointer(s, object);
 	c->tid = next_tid(c->tid);
 	local_irq_restore(flags);

