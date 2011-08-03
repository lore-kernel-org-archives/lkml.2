Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab1HCGGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 02:06:21 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:43850 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab1HCGGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 02:06:16 -0400
Message-ID: <4E38E510.8010009@oracle.com>
Date: Wed, 03 Aug 2011 14:05:04 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
CC: Joe Jin <joe.jin@oracle.com>, Daniel Stodden <daniel.stodden@citrix.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Annie Li <annie.li@oracle.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Kurt C Hackel <KURT.HACKEL@oracle.com>,
        Greg Marsden <greg.marsden@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH -v2 1/3] xen-blkback: add remove_requested to xen_blkif and
 some declares
References: <4E38E4A2.3070003@oracle.com>
In-Reply-To: <4E38E4A2.3070003@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090203.4E38E529.0008,ss=1,re=0.000,fgs=0
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add remove_requested to xen_blkif and some declares.

Signed-off-by: Joe Jin <joe.jin@oracle.com>
Cc: Daniel Stodden <daniel.stodden@citrix.com>
Cc: Jens Axboe <jaxboe@fusionio.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Annie Li <annie.li@oracle.com>
Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>
---
 drivers/block/xen-blkback/common.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index 9e40b28..acda757 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -49,6 +49,7 @@
 	pr_debug(DRV_PFX "(%s:%d) " fmt ".\n",	\
 		 __func__, __LINE__, ##args)
 
+#define WPRINTK(fmt, args...) printk(KERN_WARNING "xen-blkback: " fmt, ##args)
 
 /* Not a real protocol.  Used to generate ring structs which contain
  * the elements common to all protocols only.  This way we get a
@@ -145,6 +146,7 @@ struct xen_blkif {
 	/* Back pointer to the backend_info. */
 	struct backend_info	*be;
 	/* Private fields. */
+	bool			remove_requested;
 	spinlock_t		blk_ring_lock;
 	atomic_t		refcnt;
 
@@ -198,6 +200,9 @@ int xen_blkbk_flush_diskcache(struct xenbus_transaction xbt,
 
 struct xenbus_device *xen_blkbk_xenbus(struct backend_info *be);
 
+void xen_vbd_sync(struct xen_vbd *vbd);
+void xen_blkback_close(struct xen_blkif *blkif);
+
 static inline void blkif_get_x86_32_req(struct blkif_request *dst,
 					struct blkif_x86_32_request *src)
 {

