Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab1DOTRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 15:17:30 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58215 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab1DOTR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 15:17:29 -0400
Subject: [PATCH] make new gfp.h BUG_ON() in to VM_BUG_ON()
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jan Beulich <JBeulich@novell.com>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1104150945230.5863@router.home>
References: <1302795695.14658.6801.camel@nimitz>
	 <20110414132220.970cfb2a.akpm@linux-foundation.org>
	 <1302817191.16562.1036.camel@nimitz>
	 <alpine.DEB.2.00.1104150945230.5863@router.home>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 15 Apr 2011 12:16:29 -0700
Message-ID: <1302894989.16562.3884.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-15 at 09:45 -0500, Christoph Lameter wrote:
> You can also remove the #ifdef. Use VM_BUG_ON.

Gotcha.

--

This goes on top of

	include-linux-gfph-work-around-apparent-sparse-confusion.patch

already in the -mm tree.

VM_BUG_ON() if effectively a BUG_ON() undef #ifdef CONFIG_DEBUG_VM.
That is exactly what we have here now, and two different folks have
suggested doing it this way.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/include/linux/gfp.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN include/linux/gfp.h~make-gfp_h-BUG_ON-in-too-VM_BUG_ON include/linux/gfp.h
--- linux-2.6.git/include/linux/gfp.h~make-gfp_h-BUG_ON-in-too-VM_BUG_ON	2011-04-15 10:59:24.192432223 -0700
+++ linux-2.6.git-dave/include/linux/gfp.h	2011-04-15 10:59:39.384429223 -0700
@@ -249,9 +249,7 @@ static inline enum zone_type gfp_zone(gf
 
 	z = (GFP_ZONE_TABLE >> (bit * ZONES_SHIFT)) &
 					 ((1 << ZONES_SHIFT) - 1);
-#ifdef CONFIG_DEBUG_VM
-	BUG_ON((GFP_ZONE_BAD >> bit) & 1);
-#endif
+	VM_BUG_ON((GFP_ZONE_BAD >> bit) & 1);
 	return z;
 }
 
_


-- Dave

