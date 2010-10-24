Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511Ab0JXLSR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 07:18:17 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:54637 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932492Ab0JXLSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 07:18:16 -0400
Date: Sun, 24 Oct 2010 13:12:21 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: drbd-dev@lists.linbit.com
Cc: drbd-user@lists.linbit.com, linux-kernel@vger.kernel.org
Subject: [PATCH] block/drbd: fix error path
Message-ID: <20101024131221.1cf6e0f2@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Failure to create drbd_ee_mempool appears not to get checked.
Looks like a copy-and-paste problem to me.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/block/drbd/drbd_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index c5dfe64..25c7a73 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2982,7 +2982,7 @@ static int drbd_create_mempools(void)
 
 	drbd_ee_mempool = mempool_create(number,
 		mempool_alloc_slab, mempool_free_slab, drbd_ee_cache);
-	if (drbd_request_mempool == NULL)
+	if (drbd_ee_mempool == NULL)
 		goto Enomem;
 
 	/* drbd's page pool */
-- 
1.7.2.2
