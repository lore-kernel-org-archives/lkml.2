Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab2KZTHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 14:07:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:34051 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab2KZTHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 14:07:36 -0500
Message-ID: <50B3BDED.1030306@infradead.org>
Date: Mon, 26 Nov 2012 11:07:25 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Russ Gorby <russ.gorby@intel.com>
Subject: [PATCH -next] tty/serial: fix ifx6x60.c declaration warning
References: <20121127011738.9ecd7971a7ea2e3d09a9450d@canb.auug.org.au>
In-Reply-To: <20121127011738.9ecd7971a7ea2e3d09a9450d@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix gcc warning of mixed data/code:

drivers/tty/serial/ifx6x60.c:516:2: warning: ISO C90 forbids mixed declarations and code

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Russ Gorby <russ.gorby@intel.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org
---
 drivers/tty/serial/ifx6x60.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next-20121126.orig/drivers/tty/serial/ifx6x60.c
+++ linux-next-20121126/drivers/tty/serial/ifx6x60.c
@@ -510,10 +510,11 @@ static int ifx_spi_write(struct tty_stru
 	unsigned char *tmp_buf = (unsigned char *)buf;
 	unsigned long flags;
 	bool is_fifo_empty;
+	int tx_count;
 
 	spin_lock_irqsave(&ifx_dev->fifo_lock, flags);
 	is_fifo_empty = kfifo_is_empty(&ifx_dev->tx_fifo);
-	int tx_count = kfifo_in(&ifx_dev->tx_fifo, tmp_buf, count);
+	tx_count = kfifo_in(&ifx_dev->tx_fifo, tmp_buf, count);
 	spin_unlock_irqrestore(&ifx_dev->fifo_lock, flags);
 	if (is_fifo_empty)
 		mrdy_assert(ifx_dev);
