Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259Ab0JZTs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 15:48:28 -0400
Received: from moh2-ve1.go2.pl ([193.17.41.186]:55675 "EHLO moh1-ve1.go2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757669Ab0JZTs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:48:26 -0400
X-Greylist: delayed 92953 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Oct 2010 15:48:26 EDT
Message-ID: <4CC73085.2070304@o2.pl>
Date: Tue, 26 Oct 2010 21:48:21 +0200
From: Maciej Szmigiero <mhej@o2.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101024 Lightning/1.0b3pre Thunderbird/3.1.5
MIME-Version: 1.0
To: linux-serial@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [SERIAL]blacklist si3052 chip
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-O2-Trust: 2, 65
X-O2-SPF: neutral
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[SERIAL]blacklist si3052 chip

Si3052-based softmodems aren't serial ports so don't bind serial driver to them.
Allows proper driver to bind to them.

Signed-off-by: Maciej Szmigiero <mhej@o2.pl>

--- a/drivers/serial/8250_pci.c	2010-10-26 20:59:32.000000000 +0200
+++ b/drivers/serial/8250_pci.c	2010-10-26 21:12:56.000000000 +0200
@@ -2275,6 +2275,8 @@
 
 static const struct pci_device_id softmodem_blacklist[] = {
 	{ PCI_VDEVICE(AL, 0x5457), }, /* ALi Corporation M5457 AC'97 Modem */
+	{ PCI_VDEVICE(MOTOROLA, 0x3052), }, /* Motorola Si3052-based modem */
+	{ PCI_DEVICE(0x1543, 0x3052), }, /* Si3052-based modem, default IDs */
 };
 
 /*


