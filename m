Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab2F0JGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:06:33 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:44935 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab2F0JGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:06:31 -0400
Date: Wed, 27 Jun 2012 12:06:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch -resend] NVMe: handle allocation failure in
 nvme_map_user_pages()
Message-ID: <20120627090623.GO31212@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627085800.GA3007@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should return here and avoid a NULL dereference.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Originally sent on Fri, 20 Jan 2012.

diff --git a/drivers/block/nvme.c b/drivers/block/nvme.c
index 38a2d06..b4d85b9 100644
--- a/drivers/block/nvme.c
+++ b/drivers/block/nvme.c
@@ -1037,6 +1037,8 @@ static struct nvme_iod *nvme_map_user_pages(struct nvme_dev *dev, int write,
 	offset = offset_in_page(addr);
 	count = DIV_ROUND_UP(offset + length, PAGE_SIZE);
 	pages = kcalloc(count, sizeof(*pages), GFP_KERNEL);
+	if (!pages)
+		return ERR_PTR(-ENOMEM);
 
 	err = get_user_pages_fast(addr, count, 1, pages);
 	if (err < count) {
