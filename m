Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760988Ab0HEWc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:32:27 -0400
Received: from kroah.org ([198.145.64.141]:37808 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934564Ab0HEWY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:57 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Richard=20R=C3=B6jfors?= <richard.rojfors@pelagicore.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 57/67] timbuart: use __devinit and __devexit macros for probe and remove
Date: Thu,  5 Aug 2010 15:23:24 -0700
Message-Id: <1281047014-23429-57-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213528.GA13794@kroah.com>
References: <20100805213528.GA13794@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Röjfors <richard.rojfors@pelagicore.com>

Move the probe and remove functions to the devinit and devexit sections.

Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/timbuart.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/timbuart.c b/drivers/serial/timbuart.c
index 67ca642..1f36b7e 100644
--- a/drivers/serial/timbuart.c
+++ b/drivers/serial/timbuart.c
@@ -423,7 +423,7 @@ static struct uart_driver timbuart_driver = {
 	.nr = 1
 };
 
-static int timbuart_probe(struct platform_device *dev)
+static int __devinit timbuart_probe(struct platform_device *dev)
 {
 	int err, irq;
 	struct timbuart_port *uart;
@@ -489,7 +489,7 @@ err_mem:
 	return err;
 }
 
-static int timbuart_remove(struct platform_device *dev)
+static int __devexit timbuart_remove(struct platform_device *dev)
 {
 	struct timbuart_port *uart = platform_get_drvdata(dev);
 
@@ -507,7 +507,7 @@ static struct platform_driver timbuart_platform_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= timbuart_probe,
-	.remove		= timbuart_remove,
+	.remove		= __devexit_p(timbuart_remove),
 };
 
 /*--------------------------------------------------------------------------*/
-- 
1.7.2

