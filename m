Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab2ADCck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 21:32:40 -0500
Received: from ozlabs.org ([203.10.76.45]:45867 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754983Ab2ADCcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 21:32:00 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tim Waugh <tim@cyberelk.net>
Cc: linux-kernel@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] paride/pcd: fix bool verbose module parameter.
In-Reply-To: <20120103131748.GA11575@elgon.mountain>
References: <20120103131748.GA11575@elgon.mountain>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 04 Jan 2012 13:00:42 +1030
Message-ID: <87zke4ci7h.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter points out that it's an int, not a bool:

pcd.c:427:				if (verbose > 1)
pcd.c:433:				if (verbose > 1)
pcd.c:437:				if (verbose < 2)
pcd.c:506:#define DBMSG(msg)	((verbose>1)?(msg):NULL)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/block/paride/pcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -144,7 +144,7 @@ enum {D_PRT, D_PRO, D_UNI, D_MOD, D_SLV,
 static DEFINE_MUTEX(pcd_mutex);
 static DEFINE_SPINLOCK(pcd_lock);
 
-module_param(verbose, bool, 0644);
+module_param(verbose, int, 0644);
 module_param(major, int, 0);
 module_param(name, charp, 0);
 module_param(nice, int, 0);
