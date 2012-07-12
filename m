Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab2GLGJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 02:09:39 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:48154 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab2GLGJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 02:09:37 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Mark Einon <mark.einon@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Francois Romieu <romieu@fr.zoreil.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 2/2] staging/et131x: remove memset for the TCB
Date: Thu, 12 Jul 2012 11:54:28 +0545
Message-Id: <1342073368-11893-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TCB has kcalloc' ed so no need to call memset again on it.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/et131x/et131x.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 227fca9..5010894 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -2131,8 +2131,6 @@ static void et131x_init_send(struct et131x_adapter *adapter)
 
 	tx_ring->tcb_qhead = tcb;
 
-	memset(tcb, 0, sizeof(struct tcb) * NUM_TCB);
-
 	/* Go through and set up each TCB */
 	for (ct = 0; ct++ < NUM_TCB; tcb++)
 		/* Set the link pointer in HW TCB to the next TCB in the
-- 
1.7.9.5

