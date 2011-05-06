Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab1EFSHL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 14:07:11 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:36266 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752425Ab1EFSHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 14:07:05 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: K4V8yOwVM1kta7Vij1_AEKeII6VD4qpibPcV4AEWfiZSnfB
 eayupZrdg9_1A8yk56_4hKglYTJ4kHZpYtLd7NEp.38K8XPIOQLb9OnQio9M
 9oNhs0l1ZWtGocw3.XubpFyRFguPfbfBnWJ25v9FCJEhD.UIng8XO_jzHtx1
 apk_KqlX.UcWUGjjszFPsBVTAkMQ.1chaQyeJiZKxtJqKmhMzdbd07gEDwbF
 1z_IA3uZA1hejiQc.XSmTB5Q0UgfhowtLOp_A2TzIkP61on9It4FBvtLcXSj
 ujtEjnYwuLYI7wCzZwHHDsPZ.B7iPTD2GSbqD7kYtiCokaX.w
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110506180702.930651504@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 06 May 2011 13:05:56 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv4 15/16] slub: Not necessary to check for empty slab on load_freelist
References: <20110506180541.990069206@linux.com>
Content-Disposition: inline; filename=goto_load_freelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Load freelist is now only branched to if there are objects available.
So no need to check.

---
 mm/slub.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-05-06 09:06:34.000000000 -0500
+++ linux-2.6/mm/slub.c	2011-05-06 09:06:37.000000000 -0500
@@ -1966,14 +1966,13 @@ static void *__slab_alloc(struct kmem_ca
 				"__slab_alloc"));
 	}
 
-load_freelist:
-	VM_BUG_ON(!page->frozen);
-
 	if (unlikely(!object)) {
 		c->page = NULL;
 		goto new_slab;
 	}
 
+load_freelist:
+	VM_BUG_ON(!page->frozen);
 	c->freelist = get_freepointer(s, object);
 	c->tid = next_tid(c->tid);
 	local_irq_restore(flags);

