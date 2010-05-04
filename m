Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934371Ab0EDWTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 18:19:11 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:48583 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760226Ab0EDWTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 18:19:07 -0400
X-Auth-Info: klgDfTrtaRLsaDBHmJ+5isjfMzJNHSdDdWQVybqADas=
From: Anatolij Gustschin <agust@denx.de>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, grant.likely@secretlab.ca,
       leonardo.lists@gmail.com, gregkh@suse.de,
       Anatolij Gustschin <agust@denx.de>
Subject: [PATCH] serial: mpc52xx_uart: fix null pointer dereference
Date: Wed,  5 May 2010 00:18:59 +0200
Message-Id: <1273011539-13994-1-git-send-email-agust@denx.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <g2xc2d0b6ec1005041339r9c40822w7a642f9bba976820@mail.gmail.com>
References: <g2xc2d0b6ec1005041339r9c40822w7a642f9bba976820@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6acc6833510db8f72b5ef343296d97480555fda9
introduced NULL pointer dereference and kernel crash
on ppc32 machines while booting. Fix this bug now.

Reported-by: Leonardo Chiquitto <leonardo.lists@gmail.com>
Signed-off-by: Anatolij Gustschin <agust@denx.de>
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
1.7.0.4

