Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab1CORp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 13:45:27 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:43399 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758215Ab1CORpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 13:45:25 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: ynKCa7UVM1ncNfGMO6L0vnOy0_Nh51BYI4hJqOL5_ySAMu0
 PffSObIZbrJcXxj8g2.9HhP.oCYw0BqB6opwkm_JYV8PXb20Gxjbc4ZLLP4N
 .BpjwaqXqAhwcmMvnLPHMMe2d8H0_Hp5FmN4ta8Fisjf7xpZ1zK5Jz1tT7o5
 5pxicvPXHA1KuJFVarzF3OAKwXLdP6vDMNMSz26tAyjO7nWOSzECzmEAggfd
 uyJnbV.WOmufMga5yox.HGmW2orgy8zPApSsfxU0OmnxbhAVsZ6fPt5qekgL
 gMzzdifsBcQnVP.m7S7GY43iLzsJyoD5HWwlAZsrhmzBddNfB
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 15 Mar 2011 12:45:21 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the slab tree
In-Reply-To: <20110314200247.92ae2bd7.sfr@canb.auug.org.au>
Message-ID: <alpine.DEB.2.00.1103151119200.5754@router.home>
References: <20110314200247.92ae2bd7.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011, Stephen Rothwell wrote:

> mm/slub.c: In function 'slab_free':
> mm/slub.c:2124: warning: label 'redo' defined but not used
>
> Introduced by commit 8a5ec0ba42c4 ("Lockless (and preemptless) fastpaths
> for slub").
---

Subject: slub: Dont define useless label in the !CONFIG_CMPXCHG_LOCAL case

The redo label needs #ifdeffery.

Signed-off-by: Christoph Lameter <cl@linux.com>

 mm/slub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-next/mm/slub.c
===================================================================
--- linux-next.orig/mm/slub.c	2011-03-15 12:41:41.000000000 -0500
+++ linux-next/mm/slub.c	2011-03-15 12:43:06.000000000 -0500
@@ -2119,9 +2119,11 @@ static __always_inline void slab_free(st

 #ifndef CONFIG_CMPXCHG_LOCAL
 	local_irq_save(flags);
-#endif

+#else
 redo:
+#endif
+
 	/*
 	 * Determine the currently cpus per cpu slab.
 	 * The cpu may change afterward. However that does not matter since
