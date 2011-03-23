Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab1CWIus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 04:50:48 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:56915 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab1CWIuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 04:50:07 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 6/7] Char: moxa, remove unused variables
Date: Wed, 23 Mar 2011 09:49:59 +0100
Message-Id: <1300870200-24405-6-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300870200-24405-1-git-send-email-jslaby@suse.cz>
References: <1300870200-24405-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/tty/moxa.c:1287:2: warning: Value stored to 'port' is never read
        port = tty->index;
        ^      ~~~~~~~~~~
drivers/tty/moxa.c:1763:2: warning: Value stored to 'cflag' is never read
        cflag = termio->c_cflag;        /* termio->c_cflag */
        ^       ~~~~~~~~~~~~~~~

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/moxa.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/moxa.c b/drivers/tty/moxa.c
index 35b0c38..ffdaab3 100644
--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -1281,10 +1281,8 @@ static int moxa_tiocmset(struct tty_struct *tty,
 			 unsigned int set, unsigned int clear)
 {
 	struct moxa_port *ch;
-	int port;
 	int dtr, rts;
 
-	port = tty->index;
 	mutex_lock(&moxa_openlock);
 	ch = tty->driver_data;
 	if (!ch) {
@@ -1756,11 +1754,9 @@ static int MoxaPortSetTermio(struct moxa_port *port, struct ktermios *termio,
 		speed_t baud)
 {
 	void __iomem *ofsAddr;
-	tcflag_t cflag;
 	tcflag_t mode = 0;
 
 	ofsAddr = port->tableAddr;
-	cflag = termio->c_cflag;	/* termio->c_cflag */
 
 	mode = termio->c_cflag & CSIZE;
 	if (mode == CS5)
-- 
1.7.4.1


