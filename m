Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962Ab0HJWDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:03:37 -0400
Received: from kroah.org ([198.145.64.141]:45056 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933489Ab0HJWAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 18:00:51 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kulikov Vasiliy <segooon@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 60/68] mxser: remove unnesesary NULL check
Date: Tue, 10 Aug 2010 14:59:22 -0700
Message-Id: <1281477570-18944-60-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100810214425.GB17385@kroah.com>
References: <20100810214425.GB17385@kroah.com>
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

