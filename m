Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660Ab0JANWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 09:22:47 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:65327 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587Ab0JANWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 09:22:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hps9FUyhQW1OINvi+bNuiEKszduHbGw9c8x8W9SSZBR30m6TfR5GfF7Q31Z3LX32Xn
         7l1qtsybxHYlcTtsXN6QV8eJLesb5A3ZZkcE2puzb1mKODMW9lPrn2Wij8KW645My+P9
         hKlSkZJPGD4QH9kNnL1tnuwsHb/5ibIfUASKE=
Date: Fri, 1 Oct 2010 17:22:37 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Tobias Klauser <tklauser@distanz.ch>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] altera_uart: Fixup type usage of port flags
Message-ID: <20101001132237.GF25897@oksana.dev.rtsoft.ru>
References: <20101001132045.GA9649@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101001132045.GA9649@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

port->flags is of type upf_t, which corresponds to UPF_* flags.

ASYNC_BOOT_AUTOCONF is an unsigned integer, which happen to
be the same as UPF_BOOT_AUTOCONF.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---
 drivers/serial/altera_uart.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/altera_uart.c b/drivers/serial/altera_uart.c
index 99e007f..304181c 100644
--- a/drivers/serial/altera_uart.c
+++ b/drivers/serial/altera_uart.c
@@ -420,7 +420,7 @@ int __init early_altera_uart_setup(struct altera_uart_platform_uart *platp)
 		port->iotype = SERIAL_IO_MEM;
 		port->irq = platp[i].irq;
 		port->uartclk = platp[i].uartclk;
-		port->flags = ASYNC_BOOT_AUTOCONF;
+		port->flags = UPF_BOOT_AUTOCONF;
 		port->ops = &altera_uart_ops;
 		port->private_data = platp;
 	}
@@ -550,7 +550,7 @@ static int __devinit altera_uart_probe(struct platform_device *pdev)
 	port->iotype = SERIAL_IO_MEM;
 	port->uartclk = platp->uartclk;
 	port->ops = &altera_uart_ops;
-	port->flags = ASYNC_BOOT_AUTOCONF;
+	port->flags = UPF_BOOT_AUTOCONF;
 	port->private_data = platp;
 
 	uart_add_one_port(&altera_uart_driver, port);
-- 
1.7.0.5

