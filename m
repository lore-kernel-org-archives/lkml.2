Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793Ab2LDBtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 20:49:03 -0500
Received: from dupo.coraid.com ([208.71.232.133]:38415 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751511Ab2LDBtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 20:49:02 -0500
Message-Id: <05ea4d2d22748c65234f20dbfacf6ac69377d147.1354501189.git.ecashin@coraid.com>
In-Reply-To: <cover.1354501189.git.ecashin@coraid.com>
References: <cover.1354501189.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 5/7] aoe: allow comma separator in aoe_iflist value
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Mon, 3 Dec 2012 20:48:58 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By default, the aoe driver uses any ethernet interface for AoE,
but the aoe_iflist module parameter provides a convenient way to
limit AoE traffic to a specific list of local network interfaces.

This change allows a list to be specified using the comma
character as a separator.  For example,

  modprobe aoe aoe_iflist=eth2,eth3

Before, it was inconvenient to get the quoting right in shell
scripts when setting aoe_iflist to have more than one network
interface.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h    |    2 +-
 drivers/block/aoe/aoenet.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index 0f478dc..f8d6c7e 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -11,7 +11,7 @@
 #define AOE_PARTITIONS (16)
 #endif
 
-#define WHITESPACE " \t\v\f\n"
+#define WHITESPACE " \t\v\f\n,"
 
 enum {
 	AOECMD_ATA,
diff --git a/drivers/block/aoe/aoenet.c b/drivers/block/aoe/aoenet.c
index 2e47404..71d3ea8 100644
--- a/drivers/block/aoe/aoenet.c
+++ b/drivers/block/aoe/aoenet.c
@@ -31,7 +31,7 @@ enum {
 
 static char aoe_iflist[IFLISTSZ];
 module_param_string(aoe_iflist, aoe_iflist, IFLISTSZ, 0600);
-MODULE_PARM_DESC(aoe_iflist, "aoe_iflist=\"dev1 [dev2 ...]\"");
+MODULE_PARM_DESC(aoe_iflist, "aoe_iflist=dev1[,dev2...]");
 
 static wait_queue_head_t txwq;
 static struct ktstate kts;
-- 
1.7.1

