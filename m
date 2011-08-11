Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab1HKVDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 17:03:49 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:35640 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752541Ab1HKVDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 17:03:48 -0400
Date: Thu, 11 Aug 2011 13:57:07 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>,
        xen-devel@lists.xensource.com
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH -next] xen: fix swiotlb printk and panic args
Message-Id: <20110811135707.b6dfe39c.rdunlap@xenotime.net>
In-Reply-To: <20110811162058.42b462bc80e67d7a80ecff93@canb.auug.org.au>
References: <20110811162058.42b462bc80e67d7a80ecff93@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk() and panic() args [swap them] to fix build warnings:

drivers/xen/swiotlb-xen.c:201: warning: format '%s' expects type 'char *', but argument 2 has type 'int'
drivers/xen/swiotlb-xen.c:201: warning: format '%d' expects type 'int', but argument 3 has type 'char *'
drivers/xen/swiotlb-xen.c:202: warning: format '%s' expects type 'char *', but argument 2 has type 'int'
drivers/xen/swiotlb-xen.c:202: warning: format '%d' expects type 'int', but argument 3 has type 'char *'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/xen/swiotlb-xen.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20110811.orig/drivers/xen/swiotlb-xen.c
+++ linux-next-20110811/drivers/xen/swiotlb-xen.c
@@ -198,8 +198,8 @@ error:
 		      (xen_io_tlb_nslabs << IO_TLB_SHIFT) >> 20);
 		goto retry;
 	}
-	xen_raw_printk("%s (rc:%d)", rc, m);
-	panic("%s (rc:%d)", rc, m);
+	xen_raw_printk("%s (rc:%d)", m, rc);
+	panic("%s (rc:%d)", m, rc);
 }
 
 void *
