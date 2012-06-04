Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab2FDEas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 00:30:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62853 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab2FDEar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 00:30:47 -0400
Date: Mon, 4 Jun 2012 13:30:40 +0900
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <jaxboe@fusionio.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] block: fix return value on cfq_init() failure
Message-ID: <20120604043040.GA21357@google.com>
References: <20120601112954.GC3535@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120601112954.GC3535@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cfq_init() would return zero after kmem cache creation failure.  Fix
so that it returns -ENOMEM.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/cfq-iosched.c |    1 +
 1 file changed, 1 insertion(+)

--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -4202,6 +4202,7 @@ static int __init cfq_init(void)
 	if (ret)
 		return ret;
 
+	ret = -ENOMEM;
 	cfq_pool = KMEM_CACHE(cfq_queue, 0);
 	if (!cfq_pool)
 		goto err_pol_unreg;
