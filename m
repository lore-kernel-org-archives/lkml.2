Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100Ab0KLVnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:43:49 -0500
Received: from kroah.org ([198.145.64.141]:41597 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933057Ab0KLVlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:41:12 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Maciej Szmigiero <mhej@o2.pl>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/19] SERIAL: blacklist si3052 chip
Date: Fri, 12 Nov 2010 13:40:55 -0800
Message-Id: <1289598066-10112-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101112213215.GB9294@kroah.com>
References: <20101112213215.GB9294@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maciej Szmigiero <mhej@o2.pl>

[SERIAL]blacklist si3052 chip

Si3052-based softmodems aren't serial ports so don't bind serial driver to them.
Allows proper driver to bind to them.

Signed-off-by: Maciej Szmigiero <mhej@o2.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/8250_pci.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index 2ada93e..842e3b2 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -2285,6 +2285,8 @@ static struct pciserial_board pci_boards[] __devinitdata = {
 
 static const struct pci_device_id softmodem_blacklist[] = {
 	{ PCI_VDEVICE(AL, 0x5457), }, /* ALi Corporation M5457 AC'97 Modem */
+	{ PCI_VDEVICE(MOTOROLA, 0x3052), }, /* Motorola Si3052-based modem */
+	{ PCI_DEVICE(0x1543, 0x3052), }, /* Si3052-based modem, default IDs */
 };
 
 /*
-- 
1.7.1

