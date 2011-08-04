Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab1HDINM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 04:13:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:41889 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499Ab1HDING (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 04:13:06 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] 8250: Fix compiler warning
Date: Thu,  4 Aug 2011 03:13:01 -0500
Message-Id: <1312445581-16283-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/tty/serial/8250.c: In function 'serial8250_shutdown':
drivers/tty/serial/8250.c:1775:19: warning: 'i' may be used uninitialized in this function

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 drivers/tty/serial/8250.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index f2dfec8..44de222 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -1772,7 +1772,7 @@ static int serial_link_irq_chain(struct uart_8250_port *up)
 
 static void serial_unlink_irq_chain(struct uart_8250_port *up)
 {
-	struct irq_info *i;
+	struct irq_info *i = NULL;
 	struct hlist_node *n;
 	struct hlist_head *h;
 
-- 
1.7.3.4

