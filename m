Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab2IRTyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 15:54:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359Ab2IRTyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 15:54:19 -0400
Date: Tue, 18 Sep 2012 15:54:12 -0400
From: Dave Jones <davej@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: Taint kernel when we detect a corrupted slab.
Message-ID: <20120918195412.GB27689@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Rientjes <rientjes@google.com>,
	Christoph Lameter <cl@linux.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Pekka Enberg <penberg@kernel.org>
References: <20120918150543.GA14718@redhat.com>
 <00000139da509650-e5756e3f-f538-4735-afcd-c3c8ac9035b7-000000@email.amazonses.com>
 <alpine.DEB.2.00.1209181227190.25146@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1209181227190.25146@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 12:27:58PM -0700, David Rientjes wrote:
 > On Tue, 18 Sep 2012, Christoph Lameter wrote:
 > 
 > > On Tue, 18 Sep 2012, Dave Jones wrote:
 > > 
 > > > It doesn't seem worth adding a new taint flag for this, so just re-use
 > > > the one from 'bad page'
 > > 
 > > Acked-by: Christoph Lameter <cl@linux.com>
 > 
 > [Fixing Pekka's email address]
 > 
 > Dave, would you like to add something similar to __slab_error() for 
 > CONFIG_SLAB?

Sure. This ?

	Dave

-- 


Taint kernel when we detect a corrupted slab.

It doesn't seem worth adding a new taint flag for this, so just re-use
the one from 'bad page'

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/mm/slub.c b/mm/slub.c
index 2fdd96f..0c5009d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -568,6 +568,8 @@ static void slab_bug(struct kmem_cache *s, char *fmt, ...)
 	printk(KERN_ERR "BUG %s (%s): %s\n", s->name, print_tainted(), buf);
 	printk(KERN_ERR "----------------------------------------"
 			"-------------------------------------\n\n");
+
+	add_taint(TAINT_BAD_PAGE);
 }
 
 static void slab_fix(struct kmem_cache *s, char *fmt, ...)
diff --git a/mm/slab.c b/mm/slab.c
index c685475..cbce8c9 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -818,6 +818,7 @@ static void __slab_error(const char *function, struct kmem_cache *cachep,
 	printk(KERN_ERR "slab error in %s(): cache `%s': %s\n",
 	       function, cachep->name, msg);
 	dump_stack();
+	add_taint(TAINT_BAD_PAGE);
 }
 
 /*
