Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934272Ab0HEW04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:26:56 -0400
Received: from kroah.org ([198.145.64.141]:37808 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934575Ab0HEWZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:25:01 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kulikov Vasiliy <segooon@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 60/67] mxser: remove unnesesary NULL check
Date: Thu,  5 Aug 2010 15:23:27 -0700
Message-Id: <1281047014-23429-60-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213528.GA13794@kroah.com>
References: <20100805213528.GA13794@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kulikov Vasiliy <segooon@gmail.com>

mxser_transmit_chars(tty, port) is called only from mxser_interrupt().
NULL check is performed in mxser_interrupt() so it is redundant here.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
Acked-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/mxser.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index d2692d4..3fc89da 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -2193,7 +2193,7 @@ static void mxser_transmit_chars(struct tty_struct *tty, struct mxser_port *port
 	port->mon_data.up_txcnt += (cnt - port->xmit_cnt);
 	port->icount.tx += (cnt - port->xmit_cnt);
 
-	if (port->xmit_cnt < WAKEUP_CHARS && tty)
+	if (port->xmit_cnt < WAKEUP_CHARS)
 		tty_wakeup(tty);
 
 	if (port->xmit_cnt <= 0) {
-- 
1.7.2

