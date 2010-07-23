Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab0GWQfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 12:35:08 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46189 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab0GWQfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 12:35:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=p5Vti1PKkwPlgQd9ZYKmc4olLxxBFPbJ0mC6tR6rSF0kOAcRH7mj2iEnsE5TDvywmK
         IWbuqNsDhMYBo2XUdywLNPEiE+pP5XKJJ8kpjb2bBcRCcEdl+ixTjPzfIQnWUqzEPm0H
         nNoIdlBfnocsvCqQsbTMk9oY3GiYm3+fpPWzc=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Jiri Slaby <jirislaby@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] char: mxser: remove unnesesary NULL check
Date: Fri, 23 Jul 2010 20:34:53 +0400
Message-Id: <1279902893-27006-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mxser_transmit_chars(tty, port) is called only from mxser_interrupt().
NULL check is performed in mxser_interrupt() so it is redundant here.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
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
1.7.0.4

