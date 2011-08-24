Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab1HXWc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 18:32:56 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:33404 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab1HXWby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 18:31:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: JBeulich@novell.com, jeremy@goop.org, ian.campbell@citrix.com,
        Randy Dunlap <rdunlap@xenotime.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/5] xen-swiotlb: fix printk and panic args
Date: Wed, 24 Aug 2011 18:31:35 -0400
Message-Id: <1314225096-4861-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314225096-4861-1-git-send-email-konrad.wilk@oracle.com>
References: <1314225096-4861-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E557BD3.006A:SCFMA922111,ss=1,re=-4.000,fgs=0
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
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/swiotlb-xen.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index ea8c289..0408f32 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -197,8 +197,8 @@ error:
 		      (xen_io_tlb_nslabs << IO_TLB_SHIFT) >> 20);
 		goto retry;
 	}
-	xen_raw_printk("%s (rc:%d)", rc, m);
-	panic("%s (rc:%d)", rc, m);
+	xen_raw_printk("%s (rc:%d)", m, rc);
+	panic("%s (rc:%d)", m, rc);
 }
 
 void *
-- 
1.7.4.1

