Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab2GJXbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:31:11 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:34344 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755066Ab2GJXbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:31:09 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: zCulaNkVM1l7BqNOyZICNgXuYbbzZYC2QlWxNrKgOocvhq8
 MnKa9FaEbZO3L055UJPyiwHMMADHxDNMDBga3jFJ8tXNIFsYcMPzmZuEvj8y
 wog5jdDSGKeKwLSzkWhMbmN5Bmff9wOGxIL2nqe7bziGGJ7LV5W3TvSVcPBH
 6wmUAo_p4VLbXBLuIZJfIQ2XZ0NVclRRp3ynZcU1_HPwAxGeVqUjnNK8TnbY
 pdplgNzFEl460QchOPEqkLtc4TODIldWLN6ARErT73e5sM09Cld.4HAxBArQ
 xBFPT37bJ2BrVIQvyMv87p585bck3YrF2nNUdSznNNr_r6_7GWSifH5t4uxI
 NqR44mIcdUWUpqWy0gS74dmfZgBwVX7IavpUE1coSLRjlxOP2SGnxc_vLC23
 E
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 10 Jul 2012 18:31:05 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Christoph Lameter <christoph@linuxfoundation.org>
cc: "wfg@linux.intel.com" <wfg@linux.intel.com>,
        Pekka Enberg <penberg@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Early crashed kernel on CONFIG_SLOB
In-Reply-To: <CF1C132D-2873-408A-BCC9-B9F57BE6EDDB@linuxfoundation.org>
Message-ID: <alpine.DEB.2.00.1207101830480.5988@router.home>
References: <20120710111756.GA11351@localhost> <CF1C132D-2873-408A-BCC9-B9F57BE6EDDB@linuxfoundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the patch:

Subject: slob: Undo slob hunk

Commit fd3142a59af2012a7c5dc72ec97a4935ff1c5fc6 broke
slob since a piece of a change for a later patch slipped into
it.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slob.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/mm/slob.c
===================================================================
--- linux-2.6.orig/mm/slob.c	2012-07-06 08:38:18.851205889 -0500
+++ linux-2.6/mm/slob.c	2012-07-06 08:38:47.259205237 -0500
@@ -516,7 +516,7 @@ struct kmem_cache *kmem_cache_create(con

 	if (c) {
 		c->name = name;
-		c->size = c->object_size;
+		c->size = size;
 		if (flags & SLAB_DESTROY_BY_RCU) {
 			/* leave room for rcu footer at the end of object */
 			c->size += sizeof(struct slob_rcu);
