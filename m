Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031689Ab2K3Sti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:49:38 -0500
Received: from mail.kernel.org ([198.145.19.201]:57411 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031630Ab2K3StY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:49:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Andre Naujoks <nautsch2@googlemail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [ 20/37] can: bcm: initialize ifindex for timeouts without previous frame reception
Date: Fri, 30 Nov 2012 10:46:07 -0800
Message-Id: <20121130183859.419791430@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130183857.166228045@linuxfoundation.org>
References: <20121130183857.166228045@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 81b401100c01d2357031e874689f89bd788d13cd upstream.

Set in the rx_ifindex to pass the correct interface index in the case of a
message timeout detection. Usually the rx_ifindex value is set at receive
time. But when no CAN frame has been received the RX_TIMEOUT notification
did not contain a valid value.

Reported-by: Andre Naujoks <nautsch2@googlemail.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/can/bcm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -1085,6 +1085,9 @@ static int bcm_rx_setup(struct bcm_msg_h
 		op->sk = sk;
 		op->ifindex = ifindex;
 
+		/* ifindex for timeout events w/o previous frame reception */
+		op->rx_ifindex = ifindex;
+
 		/* initialize uninitialized (kzalloc) structure */
 		hrtimer_init(&op->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 		op->timer.function = bcm_rx_timeout_handler;


