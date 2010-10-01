Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680Ab0JANXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 09:23:35 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:65327 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339Ab0JANXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 09:23:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=l2gD0T1H8R0eSk5INrWJY1dkZ99LtNQrvDrQgAWWzSi1COSwO7eFaNkqRxXQ3cY/k4
         53xJhUmv3yBsQ/RRjFQQw1tZs2jCPCnlGuPlH2bNl/wKAd7BBn6+pyjZT1Coq3hgQAMk
         iYf9/8MmY//CISWqUteTrgX+GSrYgMmUgEeBo=
Date: Fri, 1 Oct 2010 17:23:13 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Tobias Klauser <tklauser@distanz.ch>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] altera_uart: Don't use plain integer as NULL pointer
Message-ID: <20101001132313.GH25897@oksana.dev.rtsoft.ru>
References: <20101001132045.GA9649@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101001132045.GA9649@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes sparse warning.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---
 drivers/serial/altera_uart.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/altera_uart.c b/drivers/serial/altera_uart.c
index 304181c..f50097e 100644
--- a/drivers/serial/altera_uart.c
+++ b/drivers/serial/altera_uart.c
@@ -460,7 +460,7 @@ static int __init altera_uart_console_setup(struct console *co, char *options)
 	if (co->index < 0 || co->index >= CONFIG_SERIAL_ALTERA_UART_MAXPORTS)
 		return -EINVAL;
 	port = &altera_uart_ports[co->index].port;
-	if (port->membase == 0)
+	if (!port->membase)
 		return -ENODEV;
 
 	if (options)
-- 
1.7.0.5
