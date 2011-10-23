Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab1JWJYp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 05:24:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63075 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336Ab1JWJYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 05:24:37 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 12/12] staging: et131x: Remove redundant check and return statement
Date: Sun, 23 Oct 2011 10:22:54 +0100
Message-Id: <1319361774-3148-13-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319361774-3148-1-git-send-email-mark.einon@gmail.com>
References: <1319361774-3148-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In nic_send_packet(), by the time 'frag' is checked to be zero, it never
is - the for loop has been entered (as nr_frags is always > 0) and frag
has been incremented at least once. Remove the check and associated
error return.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 98c6974..45b88d4 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -3412,9 +3412,6 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 		}
 	}
 
-	if (frag == 0)
-		return -EIO;
-
 	if (phydev && phydev->speed == SPEED_1000) {
 		if (++adapter->tx_ring.since_irq == PARM_TX_NUM_BUFS_DEF) {
 			/* Last element & Interrupt flag */
-- 
1.7.6.4

