Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab2CWKHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 06:07:35 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:38417 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753022Ab2CWKHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 06:07:18 -0400
X-Authenticated: #9008106
X-Provags-ID: V01U2FsdGVkX1/r/X5wQxrrHQaGK0n5HB6jvrfR7BuPDWgEziW9ss
	I+s+7KUA32yXh3
Date: Fri, 23 Mar 2012 11:06:37 +0100
From: Michael Brunner <mibru@gmx.de>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Subject: [PATCHv2] pch_uart: Add Kontron COMe-mTT10 uart clock quirk
Message-ID: <20120323110637.63aa2f64@hyperion>
In-Reply-To: <4F6B9E7B.9090005@linux.intel.com>
References: <20120322211903.6776ab18@mail.gmx.de>
	<4F6B8E1B.9080802@linux.intel.com>
	<20120322223112.291e0c59@mail.gmx.de>
	<4F6B9E7B.9090005@linux.intel.com>
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

As suggested by Darren Hart the comparison in this patch version is
placed after the FRI2 checks to ensure it will also work with possible
upcoming changes to the FRI2 firmware.

This patch follows the patchset submitted by Darren Hart at
commit a46f5533ecfc7bbdd646d84fdab8656031a715c6.

Signed-off-by: Michael Brunner <mibru@gmx.de>
---
 drivers/tty/serial/pch_uart.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 332f2eb..dd69c95 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -210,6 +210,7 @@ enum {
 #define CMITC_UARTCLK   192000000 /* 192.0000 MHz */
 #define FRI2_64_UARTCLK  64000000 /*  64.0000 MHz */
 #define FRI2_48_UARTCLK  48000000 /*  48.0000 MHz */
+#define NTC1_UARTCLK     64000000 /*  64.0000 MHz */
 
 struct pch_uart_buffer {
 	unsigned char *buf;
@@ -388,6 +389,12 @@ static int pch_uart_get_uartclk(void)
 	if (cmp && strstr(cmp, "Fish River Island II"))
 		return FRI2_48_UARTCLK;
 
+	/* Kontron COMe-mTT10 (nanoETXexpress-TT) */
+	cmp = dmi_get_system_info(DMI_BOARD_NAME);
+	if (cmp && (strstr(cmp, "COMe-mTT") ||
+		    strstr(cmp, "nanoETXexpress-TT")))
+		return NTC1_UARTCLK;
+
 	return DEFAULT_UARTCLK;
 }
 
