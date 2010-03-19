Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab0CSPSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 11:18:46 -0400
Received: from kroah.org ([198.145.64.141]:45879 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079Ab0CSPSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 11:18:41 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tobias Klauser <tklauser@distanz.ch>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kumar Gala <galak@gate.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 6/7] tty: cpm_uart: use resource_size()
Date: Fri, 19 Mar 2010 08:18:35 -0700
Message-Id: <1269011916-8836-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <20100319151326.GC8541@kroah.com>
References: <20100319151326.GC8541@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tobias Klauser <tklauser@distanz.ch>

Use the resource_size function instead of manually calculating the
resource size.  This reduces the chance of introducing off-by-one errors.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kumar Gala <galak@gate.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/cpm_uart/cpm_uart_cpm2.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/cpm_uart/cpm_uart_cpm2.c b/drivers/serial/cpm_uart/cpm_uart_cpm2.c
index a9802e7..722eac1 100644
--- a/drivers/serial/cpm_uart/cpm_uart_cpm2.c
+++ b/drivers/serial/cpm_uart/cpm_uart_cpm2.c
@@ -61,7 +61,7 @@ void __iomem *cpm_uart_map_pram(struct uart_cpm_port *port,
 	void __iomem *pram;
 	unsigned long offset;
 	struct resource res;
-	unsigned long len;
+	resource_size_t len;
 
 	/* Don't remap parameter RAM if it has already been initialized
 	 * during console setup.
@@ -74,7 +74,7 @@ void __iomem *cpm_uart_map_pram(struct uart_cpm_port *port,
 	if (of_address_to_resource(np, 1, &res))
 		return NULL;
 
-	len = 1 + res.end - res.start;
+	len = resource_size(&res);
 	pram = ioremap(res.start, len);
 	if (!pram)
 		return NULL;
-- 
1.7.0.2

