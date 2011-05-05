Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab1EESzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 14:55:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41693 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab1EESzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 14:55:41 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        xen-devel@lists.xensource.com
Cc: daniel.stodden@citrix.com, stefano.stabellini@eu.citrix.com,
        Ian.Campbell@citrix.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/3] xen-blkfront: Provide for 'feature-flush-cache' the BLKIF_OP_WRITE_FLUSH_CACHE operation.
Date: Thu,  5 May 2011 14:55:20 -0400
Message-Id: <1304621721-22608-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304621721-22608-1-git-send-email-konrad.wilk@oracle.com>
References: <1304621721-22608-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4DC2F2A7.00CA:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The operation BLKIF_OP_WRITE_FLUSH_CACHE has existed in the Xen
tree header file for years but it was never present in the Linux tree
because the frontend (nor the backend) supported this interface.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 include/xen/interface/io/blkif.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/xen/interface/io/blkif.h b/include/xen/interface/io/blkif.h
index 61e523a..3d5d6db 100644
--- a/include/xen/interface/io/blkif.h
+++ b/include/xen/interface/io/blkif.h
@@ -45,6 +45,19 @@ typedef uint64_t blkif_sector_t;
 #define BLKIF_OP_WRITE_BARRIER     2
 
 /*
+ * Recognised if "feature-flush-cache" is present in backend xenbus
+ * info.  A flush will ask the underlying storage hardware to flush its
+ * non-volatile caches as appropriate.  The "feature-flush-cache" node
+ * contains a boolean indicating whether flush requests are likely to
+ * succeed or fail. Either way, a flush request may fail at any time
+ * with BLKIF_RSP_EOPNOTSUPP if it is unsupported by the underlying
+ * block-device hardware. The boolean simply indicates whether or not it
+ * is worthwhile for the frontend to attempt flushes.  If a backend does
+ * not recognise BLKIF_OP_WRITE_FLUSH_CACHE, it should *not* create the
+ * "feature-flush-cache" node!
+ */
+#define BLKIF_OP_FLUSH_DISKCACHE   3
+/*
  * Maximum scatter/gather segments per request.
  * This is carefully chosen so that sizeof(struct blkif_ring) <= PAGE_SIZE.
  * NB. This could be 12 if the ring indexes weren't stored in the same page.
-- 
1.7.4.1

