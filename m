Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965106Ab2CVUTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 16:19:17 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:55815 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759468Ab2CVUTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 16:19:07 -0400
X-Authenticated: #9008106
X-Provags-ID: V01U2FsdGVkX1+nV+56LAmnRwPu6zFN9VQa1kUfsAX4uzywacLA+M
	mA3sjJjkStGS7l
Date: Thu, 22 Mar 2012 21:19:03 +0100
From: Michael Brunner <mibru@gmx.de>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Alan Cox" <alan@linux.intel.com>,
        "Darren Hart" <dvhart@linux.intel.com>, linux-serial@vger.kernel.org
Subject: [PATCH] pch_uart: Add Kontron COMe-mTT10 uart clock quirk
Message-ID: <20120322211903.6776ab18@mail.gmx.de>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add UART clock quirk for the Kontron COMe-mTT10 module.
The board has previously been called nanoETXexpress-TT, therefore this
is also checked. 

This patch follows the patchset submitted by Darren Hart at
commit a46f5533ecfc7bbdd646d84fdab8656031a715c6.

Signed-off-by: Michael Brunner <mibru@gmx.de>
---
 drivers/tty/serial/pch_uart.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 332f2eb..0ab5295 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -210,6 +210,7 @@ enum {
 #define CMITC_UARTCLK   192000000 /* 192.0000 MHz */
 #define FRI2_64_UARTCLK  64000000 /*  64.0000 MHz */
 #define FRI2_48_UARTCLK  48000000 /*  48.0000 MHz */
+#define NTC1_UARTCLK     64000000 /*  64.0000 MHz */
 
 struct pch_uart_buffer {
 	unsigned char *buf;
@@ -379,6 +380,10 @@ static int pch_uart_get_uartclk(void)
 	cmp = dmi_get_system_info(DMI_BOARD_NAME);
 	if (cmp && strstr(cmp, "CM-iTC"))
 		return CMITC_UARTCLK;
+	/* Kontron COMe-mTT10 (nanoETXexpress-TT) */
+	if (cmp && (strstr(cmp, "COMe-mTT") ||
+		    strstr(cmp, "nanoETXexpress-TT")))
+		return NTC1_UARTCLK;
 
 	cmp = dmi_get_system_info(DMI_BIOS_VERSION);
 	if (cmp && strnstr(cmp, "FRI2", 4))
