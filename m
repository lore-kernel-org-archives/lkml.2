Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106Ab2GBVQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 17:16:38 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43850 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209Ab2GBVQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 17:16:37 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] zsmalloc: add details to zs_map_object boiler plate
Date: Mon,  2 Jul 2012 16:15:51 -0500
Message-Id: <1341263752-10210-4-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341263752-10210-1-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1341263752-10210-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070221-9360-0000-0000-000008078896
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add information on the usage limits of zs_map_object()

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 drivers/staging/zsmalloc/zsmalloc-main.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index 4942d41..abf7c13 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -747,7 +747,12 @@ EXPORT_SYMBOL_GPL(zs_free);
  *
  * Before using an object allocated from zs_malloc, it must be mapped using
  * this function. When done with the object, it must be unmapped using
- * zs_unmap_object
+ * zs_unmap_object.
+ *
+ * Only one object can be mapped per cpu at a time. There is no protection
+ * against nested mappings.
+ *
+ * This function returns with preemption and page faults disabled.
 */
 void *zs_map_object(struct zs_pool *pool, unsigned long handle)
 {
-- 
1.7.9.5

