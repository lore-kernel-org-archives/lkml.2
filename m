Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab0HYTHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 15:07:22 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:41212 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751724Ab0HYTHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 15:07:20 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: fFImBQkVM1nQH7Gjm4FeJLbQmxxF1ZG_Q_4HtOkPIX32UbS
 rZZig.gWM4ZdGVqCtXKJROEZE3Rp3LFPreZU0jhFo2lZRCutOKNs2kQiV.aE
 HKGZVjy65MuN6UiGOXx.J0DwPbgCxoYred_daDSrGP7eJTyT6ZlpLiagyuGw
 IbQe7PLpjhktreDmmn0.H0G5qSIFPfVwRPamAFHLmd0xeIXBwPz2mT4Ro5ml
 .Jg6cJYO5z8661OQAtbGFaJpOuVkKA_HYg4arcXkMyT9KEcQvrelMwH39FWr
 g4g--
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 25 Aug 2010 14:07:16 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-mm@kvack.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: linux-next: Tree for August 25 (mm/slub)
In-Reply-To: <20100825094559.bc652afe.randy.dunlap@oracle.com>
Message-ID: <alpine.DEB.2.00.1008251405590.22117@router.home>
References: <20100825132057.c8416bef.sfr@canb.auug.org.au> <20100825094559.bc652afe.randy.dunlap@oracle.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010, Randy Dunlap wrote:

> mm/slub.c:1732: error: implicit declaration of function 'slab_pre_alloc_hook'
> mm/slub.c:1751: error: implicit declaration of function 'slab_post_alloc_hook'
> mm/slub.c:1881: error: implicit declaration of function 'slab_free_hook'
> mm/slub.c:1886: error: implicit declaration of function 'slab_free_hook_irq'

Empty functions are missing if the runtime debuggability option is
compiled
out.


Subject: slub: Add dummy functions for the !SLUB_DEBUG case

Provide the fall back functions to empty hooks if SLUB_DEBUG is not set.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-08-25 14:02:43.000000000 -0500
+++ linux-2.6/mm/slub.c	2010-08-25 14:04:23.000000000 -0500
@@ -1098,6 +1098,18 @@ static inline void inc_slabs_node(struct
 							int objects) {}
 static inline void dec_slabs_node(struct kmem_cache *s, int node,
 							int objects) {}
+
+static inline int slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
+							{ return 0; }
+
+static inline void slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
+		void *object) {}
+
+static inline void slab_free_hook(struct kmem_cache *s, void *x) {}
+
+static inline void slab_free_hook_irq(struct kmem_cache *s,
+		void *object) {}
+
 #endif

 /*
