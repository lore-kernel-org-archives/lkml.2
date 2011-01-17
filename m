Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab1AQKJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 05:09:03 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34325 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab1AQKI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 05:08:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=J0iAZYq1m5bnWdiL3XYwQjLsE3Do9vbE76n1rO2hYAcPuCIEXnb+Symi/ozpG/s8wZ
         zNsnBDi1UwjQKgX+gKIWnHij5L1pQyg9vpGxj6jg2qmb0xThlx5spVhNhhW34SiBxV2+
         vjBil+Htw0aGg/md71Hwo65vM6s3R2Je/AJyQ=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] tty: serial: bfin_sport_uart: fix signedness error
Date: Mon, 17 Jan 2011 13:08:52 +0300
Message-Id: <1295258933-31395-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sport->port.irq is unsigned, check for <0 doesn't make sense.
Explicitly cast it to int to check for error.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Cannot compile this driver, so it is not tested at all.

 drivers/tty/serial/bfin_sport_uart.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/bfin_sport_uart.c b/drivers/tty/serial/bfin_sport_uart.c
index e95c524..c3ec0a6 100644
--- a/drivers/tty/serial/bfin_sport_uart.c
+++ b/drivers/tty/serial/bfin_sport_uart.c
@@ -788,7 +788,7 @@ static int __devinit sport_uart_probe(struct platform_device *pdev)
 		sport->port.mapbase = res->start;
 
 		sport->port.irq = platform_get_irq(pdev, 0);
-		if (sport->port.irq < 0) {
+		if ((int)sport->port.irq < 0) {
 			dev_err(&pdev->dev, "No sport RX/TX IRQ specified\n");
 			ret = -ENOENT;
 			goto out_error_unmap;
-- 
1.7.0.4

