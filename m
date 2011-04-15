Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab1DOUt2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 16:49:28 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:27828 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756807Ab1DOUsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 16:48:00 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: oPZ5JBQVM1ntlTXg0V_ZOJxOwmvgEMma4ZOg7bRPrw3joKT
 Uw1X7DLGPbUQXn2eLMDi5tcp1EjBUPC_oiyFZNnPkkCGGwUy7ceQnmSvdsaO
 FhcUc6E.ylet.TNpSt01mHvb4U44O72UyqgMcxWOlh8DcNRvoOwTbD64Mcnn
 .I.D9viFBEvf63VX6JZ1IKqeEjjaA4Mh.e0Dnu9Gbro3fiuMpFyHjhq7ZB4t
 d2bFNDYKCdGOme250Cb_xK_Dw8LWQ7Zh.m4.E8ReNO06cZ7.02e6q32.eKX0
 7lzDRsc7Jdu2o_K2GFUjHJhLiugddgQGHvlJgptWd.bX4oY401B1_gBbay30
 -
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110415204757.654119035@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 15 Apr 2011 15:47:50 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
Subject: [slubllv3 20/21] slub: Not necessary to check for empty slab on load_freelist
References: <20110415204730.326790555@linux.com>
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
--- linux-2.6.orig/mm/slub.c	2011-04-01 10:22:56.000000000 -0500
+++ linux-2.6/mm/slub.c	2011-04-01 10:22:58.000000000 -0500
@@ -1976,14 +1976,13 @@ static void *__slab_alloc(struct kmem_ca
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
 
 #ifdef CONFIG_CMPXCHG_LOCAL

