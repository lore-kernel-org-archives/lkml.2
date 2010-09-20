Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab0ITIxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 04:53:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:29438 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755632Ab0ITIxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 04:53:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,391,1280732400"; 
   d="scan'208";a="659043545"
Subject: [patch]cfq-iosched: do cleanup
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: jaxboe@fusionio.com
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Sep 2010 16:53:30 +0800
Message-ID: <1284972810.6598.17.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

return bool for cfq_should_idle

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 block/cfq-iosched.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/block/cfq-iosched.c
===================================================================
--- linux-2.6.orig/block/cfq-iosched.c	2010-09-21 00:27:23.000000000 +0800
+++ linux-2.6/block/cfq-iosched.c	2010-09-21 00:27:59.000000000 +0800
@@ -1882,10 +1882,10 @@
 	 * in their service tree.
 	 */
 	if (service_tree->count == 1 && cfq_cfqq_sync(cfqq))
-		return 1;
+		return true;
 	cfq_log_cfqq(cfqd, cfqq, "Not idling. st->count:%d",
 			service_tree->count);
-	return 0;
+	return false;
 }
 
 static void cfq_arm_slice_timer(struct cfq_data *cfqd)


