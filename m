Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab2GQVkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 17:40:11 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:39569 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756828Ab2GQVkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 17:40:04 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Peter Korsgaard <jacmet@sunsite.dk>
Subject: [PATCH 08/17] uartlite: remove IRQF_SAMPLE_RANDOM which is now a no-op
Date: Tue, 17 Jul 2012 17:32:27 -0400
Message-Id: <1342560756-18737-9-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.11.1.108.gb129051
In-Reply-To: <1342560756-18737-1-git-send-email-tytso@mit.edu>
References: <1342560756-18737-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the changes in the random tree, IRQF_SAMPLE_RANDOM is now a
no-op; interrupt randomness is now collected unconditionally in a very
low-overhead fashion; see commit 775f4b297b.  The IRQF_SAMPLE_RANDOM
flag was scheduled to be removed in 2009 on the
feature-removal-schedule, so this patch is preparation for the final
removal of this flag.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Peter Korsgaard <jacmet@sunsite.dk>
---
 drivers/tty/serial/uartlite.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/tty/serial/uartlite.c b/drivers/tty/serial/uartlite.c
index 6cd4143..6579ffd 100644
--- a/drivers/tty/serial/uartlite.c
+++ b/drivers/tty/serial/uartlite.c
@@ -216,8 +216,7 @@ static int ulite_startup(struct uart_port *port)
 {
 	int ret;
 
-	ret = request_irq(port->irq, ulite_isr,
-			  IRQF_SHARED | IRQF_SAMPLE_RANDOM, "uartlite", port);
+	ret = request_irq(port->irq, ulite_isr, IRQF_SHARED, "uartlite", port);
 	if (ret)
 		return ret;
 
-- 
1.7.11.1.108.gb129051

