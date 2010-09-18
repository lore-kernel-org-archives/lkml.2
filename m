Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab0IRTet (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:34:49 -0400
Received: from kroah.org ([198.145.64.141]:43338 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756733Ab0IRTPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:04 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:00 2010
Message-Id: <20100918191300.456963973@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sonic Zhang <sonic.zhang@analog.com>,
        Mike Frysinger <vapier@gentoo.org>
Subject: [037/129] serial: bfin_sport_uart: restore transmit frame sync fix
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sonic Zhang <sonic.zhang@analog.com>

commit 336746918299f2ca16b31490655b4ff7c8824c87 upstream.

The large cleanup/rewrite of resources in commit ccf68e59e93181df9353c0cc
accidentally reverted an earlier fix in commit a19e8b205915b2925aca75b.
So restore it here.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/bfin_sport_uart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -121,7 +121,7 @@ static int sport_uart_setup(struct sport
 	unsigned int sclk = get_sclk();
 
 	/* Set TCR1 and TCR2, TFSR is not enabled for uart */
-	SPORT_PUT_TCR1(up, (ITFS | TLSBIT | ITCLK));
+	SPORT_PUT_TCR1(up, (LATFS | ITFS | TFSR | TLSBIT | ITCLK));
 	SPORT_PUT_TCR2(up, size + 1);
 	pr_debug("%s TCR1:%x, TCR2:%x\n", __func__, SPORT_GET_TCR1(up), SPORT_GET_TCR2(up));
 


