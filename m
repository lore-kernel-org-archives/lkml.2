Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161957Ab2GLX3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:29:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44509 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161892Ab2GLWlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:41:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 104/187] can: c_can: precedence error in c_can_chip_config()
Date: Thu, 12 Jul 2012 15:34:20 -0700
Message-Id: <20120712191532.033482938@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit d9cb9bd63eb27ac19f26a8547128c053f43a5da8 upstream.

(CAN_CTRLMODE_LISTENONLY & CAN_CTRLMODE_LOOPBACK) is (0x02 & 0x01) which
is zero so the condition is never true.  The intent here was to test
that both flags were set.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/c_can/c_can.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -590,8 +590,8 @@ static void c_can_chip_config(struct net
 	priv->write_reg(priv, &priv->regs->control,
 			CONTROL_ENABLE_AR);
 
-	if (priv->can.ctrlmode & (CAN_CTRLMODE_LISTENONLY &
-					CAN_CTRLMODE_LOOPBACK)) {
+	if ((priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY) &&
+	    (priv->can.ctrlmode & CAN_CTRLMODE_LOOPBACK)) {
 		/* loopback + silent mode : useful for hot self-test */
 		priv->write_reg(priv, &priv->regs->control, CONTROL_EIE |
 				CONTROL_SIE | CONTROL_IE | CONTROL_TEST);


