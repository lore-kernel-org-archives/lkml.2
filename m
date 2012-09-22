Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab2IVKJe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 06:09:34 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61913 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab2IVKJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 06:09:33 -0400
MIME-Version: 1.0
Date: Sat, 22 Sep 2012 18:09:32 +0800
Message-ID: <CANEcBPR8EvBTsJ0tG+kqvn578qXnqTMwdciS_WChe9sm5yKdaw@mail.gmail.com>
Subject: [PATCH] pppoe: drop PPPOX_ZOMBIEs in pppoe_release
From: Xiaodong Xu <stid.smth@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiaodong Xu <stid.smth@gmail.com>

When PPPOE is running over a virtual ethernet interface (e.g., a
bonding interface) and the user tries to delete the interface in case
the PPPOE state is ZOMBIE, the kernel will loop forever while
unregistering net_device for the reference count is not decreased to
zero which should have been done with dev_put().

Signed-off-by: Xiaodong Xu <stid.smth@gmail.com>

---

--- linux/drivers/net/ppp/pppoe.c.orig	2012-09-19 11:49:27.921826868 +0800
+++ linux/drivers/net/ppp/pppoe.c	2012-09-22 17:44:03.642730082 +0800
@@ -570,7 +570,7 @@ static int pppoe_release(struct socket *

 	po = pppox_sk(sk);

-	if (sk->sk_state & (PPPOX_CONNECTED | PPPOX_BOUND)) {
+	if (sk->sk_state & (PPPOX_CONNECTED | PPPOX_BOUND | PPPOX_ZOMBIE)) {
 		dev_put(po->pppoe_dev);
 		po->pppoe_dev = NULL;
 	}

-- 
Regards,
Xiaodong Xu
