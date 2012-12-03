Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab2LCOwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:52:14 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43694 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755337Ab2LCOgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:10 -0500
Message-Id: <20121203143159.168011143@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:33:08 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Andre Naujoks <nautsch2@googlemail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [ 82/89] can: bcm: initialize ifindex for timeouts without previous frame
 reception
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/can/bcm.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index 6f74758..969b7cd 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -1084,6 +1084,9 @@ static int bcm_rx_setup(struct bcm_msg_head *msg_head, struct msghdr *msg,
 		op->sk = sk;
 		op->ifindex = ifindex;
 
+		/* ifindex for timeout events w/o previous frame reception */
+		op->rx_ifindex = ifindex;
+
 		/* initialize uninitialized (kzalloc) structure */
 		hrtimer_init(&op->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 		op->timer.function = bcm_rx_timeout_handler;


