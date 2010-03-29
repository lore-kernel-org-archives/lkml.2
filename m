Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab0C2Q0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:26:31 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:28438 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab0C2Q03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:26:29 -0400
Date: Mon, 29 Mar 2010 09:25:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tejun Heo <tj@kernel.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jon Masters <jcm@jonmasters.org>
Subject: [PATCH -next] kmemcheck: build failure after merge of the slabh
 tree
Message-Id: <20100329092513.6e6faf2a.randy.dunlap@oracle.com>
In-Reply-To: <20100329154208.009a8ae2.sfr@canb.auug.org.au>
References: <20100329154208.009a8ae2.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4BB0D470.0174:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Mar 2010 15:42:08 +1100 Stephen Rothwell wrote:

> Hi Tejun,
> 
> After merging the slabh tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:

This tree seems to be a bit messy.  :(

Sorry if I missed this patch in the (email) storm.

mm/kmemcheck.c also needs slab.h added to it:

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build errors due to missing slab.h:

mm/kmemcheck.c:69: error: dereferencing pointer to incomplete type
mm/kmemcheck.c:69: error: 'SLAB_NOTRACK' undeclared (first use in this function)
mm/kmemcheck.c:82: error: dereferencing pointer to incomplete type
mm/kmemcheck.c:94: error: dereferencing pointer to incomplete type
mm/kmemcheck.c:94: error: dereferencing pointer to incomplete type
mm/kmemcheck.c:94: error: 'SLAB_DESTROY_BY_RCU' undeclared (first use in this function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 mm/kmemcheck.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20100329.orig/mm/kmemcheck.c
+++ linux-next-20100329/mm/kmemcheck.c
@@ -1,6 +1,7 @@
 #include <linux/gfp.h>
 #include <linux/mm_types.h>
 #include <linux/mm.h>
+#include <linux/slab.h>
 #include <linux/kmemcheck.h>
 
 void kmemcheck_alloc_shadow(struct page *page, int order, gfp_t flags, int node)

