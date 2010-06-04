Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab0FDUtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 16:49:40 -0400
Received: from kroah.org ([198.145.64.141]:44035 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932263Ab0FDUsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 16:48:06 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tobias Klauser <tklauser@distanz.ch>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/11] serial: altera_uart: Proper section for altera_uart_remove
Date: Fri,  4 Jun 2010 13:47:55 -0700
Message-Id: <1275684477-20172-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100604204445.GB19761@kroah.com>
References: <20100604204445.GB19761@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tobias Klauser <tklauser@distanz.ch>

altera_uart_remove should be in .devexit.text

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/altera_uart.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/altera_uart.c b/drivers/serial/altera_uart.c
index 7d6afc9..0f11896 100644
--- a/drivers/serial/altera_uart.c
+++ b/drivers/serial/altera_uart.c
@@ -498,7 +498,7 @@ static int __devinit altera_uart_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int altera_uart_remove(struct platform_device *pdev)
+static int __devexit altera_uart_remove(struct platform_device *pdev)
 {
 	struct uart_port *port;
 	int i;
-- 
1.7.1

