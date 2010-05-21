Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934167Ab0EUQwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:52:22 -0400
Received: from kroah.org ([198.145.64.141]:50351 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934133Ab0EUQwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:52:16 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tobias Klauser <tklauser@distanz.ch>, Mike Frysinger <vapier@gentoo.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 23/25] serial: bfin_sport_uart: Use resource size to fix off-by-one error
Date: Fri, 21 May 2010 09:51:52 -0700
Message-Id: <1274460714-11277-23-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165113.GB11216@kroah.com>
References: <20100521165113.GB11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tobias Klauser <tklauser@distanz.ch>

Use the resource_size function instead of manually calculating the
resource size. This actually fixes an off-by-one error.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/bfin_sport_uart.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index 66cda22..e57fb3d 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -774,8 +774,7 @@ static int __devinit sport_uart_probe(struct platform_device *pdev)
 			goto out_error_free_peripherals;
 		}
 
-		sport->port.membase = ioremap(res->start,
-			res->end - res->start);
+		sport->port.membase = ioremap(res->start, resource_size(res));
 		if (!sport->port.membase) {
 			dev_err(&pdev->dev, "Cannot map sport IO\n");
 			ret = -ENXIO;
-- 
1.7.0.3

