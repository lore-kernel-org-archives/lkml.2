Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206Ab1DYJhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 05:37:37 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43556 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758140Ab1DYJhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 05:37:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 2/3] m32r: fix spin_lock_irqsave() misuse
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hirokazu Takata <takata@linux-m32r.org>, linux-m32r@ml.linux-m32r.org
In-Reply-To: <20110425183810.268B.A69D9226@jp.fujitsu.com>
References: <20110425183810.268B.A69D9226@jp.fujitsu.com>
Message-Id: <20110425183908.268F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon, 25 Apr 2011 18:37:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spin_lock_irqsave() require unsigned long. fix it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: linux-m32r@ml.linux-m32r.org
---
 drivers/tty/serial/m32r_sio.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/m32r_sio.c b/drivers/tty/serial/m32r_sio.c
index bea5c21..84db732 100644
--- a/drivers/tty/serial/m32r_sio.c
+++ b/drivers/tty/serial/m32r_sio.c
@@ -907,9 +907,10 @@ static int m32r_sio_request_port(struct uart_port *port)
 	return ret;
 }
 
-static void m32r_sio_config_port(struct uart_port *port, int flags)
+static void m32r_sio_config_port(struct uart_port *port, int unused)
 {
 	struct uart_sio_port *up = (struct uart_sio_port *)port;
+	unsigned long flags;
 
 	spin_lock_irqsave(&up->port.lock, flags);
 
-- 
1.7.3.1



