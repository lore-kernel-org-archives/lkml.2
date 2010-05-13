Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512Ab0EMTQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 15:16:46 -0400
Received: from kroah.org ([198.145.64.141]:43897 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932270Ab0EMTQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 15:16:41 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Anatolij Gustschin <agust@denx.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/3] serial: mpc52xx_uart: fix null pointer dereference
Date: Thu, 13 May 2010 12:16:37 -0700
Message-Id: <1273778199-17578-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100513191601.GA17538@kroah.com>
References: <20100513191601.GA17538@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anatolij Gustschin <agust@denx.de>

Commit 6acc6833510db8f72b5ef343296d97480555fda9
introduced NULL pointer dereference and kernel crash
on ppc32 machines while booting. Fix this bug now.

Reported-by: Leonardo Chiquitto <leonardo.lists@gmail.com>
Tested-by: Leonardo Chiquitto <leonardo.lists@gmail.com>
Signed-off-by: Anatolij Gustschin <agust@denx.de>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/mpc52xx_uart.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/mpc52xx_uart.c b/drivers/serial/mpc52xx_uart.c
index a176ab4..02469c3 100644
--- a/drivers/serial/mpc52xx_uart.c
+++ b/drivers/serial/mpc52xx_uart.c
@@ -1467,7 +1467,7 @@ mpc52xx_uart_init(void)
 	/*
 	 * Map the PSC FIFO Controller and init if on MPC512x.
 	 */
-	if (psc_ops->fifoc_init) {
+	if (psc_ops && psc_ops->fifoc_init) {
 		ret = psc_ops->fifoc_init();
 		if (ret)
 			return ret;
-- 
1.7.1

