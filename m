Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab1BPAqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:46:07 -0500
Received: from kroah.org ([198.145.64.141]:49250 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757492Ab1BPAWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:22:48 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:41 2011
Message-Id: <20110216001441.604873012@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Pavel Machek <pavel@ucw.cz>
Subject: [165/272] serial: unbreak billionton CF card
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Pavel Machek <pavel@ucw.cz>

commit d0694e2aeb815042aa0f3e5036728b3db4446f1d upstream.

Unbreak Billionton CF bluetooth card. This actually fixes a regression
on zaurus.

Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/8250.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -236,7 +236,8 @@ static const struct serial8250_config ua
 		.fifo_size	= 128,
 		.tx_loadsz	= 128,
 		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
-		.flags		= UART_CAP_FIFO | UART_CAP_EFR | UART_CAP_SLEEP,
+		/* UART_CAP_EFR breaks billionon CF bluetooth card. */
+		.flags		= UART_CAP_FIFO | UART_CAP_SLEEP,
 	},
 	[PORT_16654] = {
 		.name		= "ST16654",


