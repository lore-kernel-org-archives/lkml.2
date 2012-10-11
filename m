Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934002Ab2JKBU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:20:26 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47400 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933922Ab2JKBUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:20:22 -0400
X-Sasl-enc: yY/+aXoCw4ZuABd0x3WAVjzBR2ouKQoT7dyTOKdReWIG 1349918420
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Xiaodong Xu <stid.smth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 045/120] pppoe: drop PPPOX_ZOMBIEs in pppoe_release
Date: Thu, 11 Oct 2012 09:59:57 +0900
Message-Id: <20121011005833.769246126@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011005825.364610894@linuxfoundation.org>
References: <20121011005825.364610894@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Xiaodong Xu <stid.smth@gmail.com>

[ Upstream commit 2b018d57ff18e5405823e5cb59651a5b4d946d7b ]

When PPPOE is running over a virtual ethernet interface (e.g., a
bonding interface) and the user tries to delete the interface in case
the PPPOE state is ZOMBIE, the kernel will loop forever while
unregistering net_device for the reference count is not decreased to
zero which should have been done with dev_put().

Signed-off-by: Xiaodong Xu <stid.smth@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ppp/pppoe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -576,7 +576,7 @@ static int pppoe_release(struct socket *
 
 	po = pppox_sk(sk);
 
-	if (sk->sk_state & (PPPOX_CONNECTED | PPPOX_BOUND)) {
+	if (sk->sk_state & (PPPOX_CONNECTED | PPPOX_BOUND | PPPOX_ZOMBIE)) {
 		dev_put(po->pppoe_dev);
 		po->pppoe_dev = NULL;
 	}


