Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457Ab1FPMOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 08:14:33 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:40362 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756846Ab1FPMO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 08:14:29 -0400
Date: Thu, 16 Jun 2011 14:14:27 +0200
From: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>
To: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: christian.dietrich@informatik.uni-erlangen.de
Subject: [PATCH 09/11] xen/xenbus: use printk_ratelimited() instead of
 printk_ratelimit()
Message-ID: <d2bc569719b3b1d8271d1f4b2c4080bbc7527e04.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
References: <cover.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since printk_ratelimit() shouldn't be used anymore (see comment in
include/linux/printk.h), replace it with printk_ratelimited()

Signed-off-by: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>
---
 drivers/xen/xenbus/xenbus_xs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
index 5534690..4055858 100644
--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -44,6 +44,7 @@
 #include <linux/rwsem.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/ratelimit.h>
 #include <xen/xenbus.h>
 #include "xenbus_comms.h"
 
@@ -270,8 +271,7 @@ static void *xs_talkv(struct xenbus_transaction t,
 	}
 
 	if (msg.type != type) {
-		if (printk_ratelimit())
-			printk(KERN_WARNING
+		`printk_ratelimited(KERN_WARNING
 			       "XENBUS unexpected type [%d], expected [%d]\n",
 			       msg.type, type);
 		kfree(ret);
-- 
1.7.4.1

