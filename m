Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab0HQH7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 03:59:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36166 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab0HQH7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 03:59:12 -0400
From: Michal Simek <monstr@monstr.eu>
To: michal.simek@petalogix.com
Cc: Michal Simek <monstr@monstr.eu>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] serial: 8250: Initialize pointer to irq_info
Date: Tue, 17 Aug 2010 09:59:06 +0200
Message-Id: <1282031947-16483-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize "i" irq_info pointer in serial_unlink_irq_chain.

Compilation warning:
  CC      drivers/serial/8250.o
drivers/serial/8250.c: In function 'serial8250_shutdown':
drivers/serial/8250.c:1701: warning: 'i' may be used uninitialized in this function

Signed-off-by: Michal Simek <monstr@monstr.eu>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Alan Cox <alan@linux.intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Ralf Baechle <ralf@linux-mips.org>
CC: Manuel Lauss <manuel.lauss@googlemail.com>
CC: linux-serial@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 drivers/serial/8250.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 24110f6..6c847d3 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1698,7 +1698,7 @@ static int serial_link_irq_chain(struct uart_8250_port *up)
 
 static void serial_unlink_irq_chain(struct uart_8250_port *up)
 {
-	struct irq_info *i;
+	struct irq_info *i = NULL;
 	struct hlist_node *n;
 	struct hlist_head *h;
 
-- 
1.5.5.6

