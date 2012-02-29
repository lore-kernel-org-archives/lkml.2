Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030220Ab2B2SZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 13:25:39 -0500
Received: from mga01.intel.com ([192.55.52.88]:12173 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965950Ab2B2SZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 13:25:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="131109400"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Feng Tang <feng.tang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Subject: [PATCH 3/4] pch_uart: Add user_uartclk parameter
Date: Wed, 29 Feb 2012 10:24:46 -0800
Message-Id: <8d2f6dc994198252c7afe323bba6aa6b4cd3dd83.1330539597.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <8b7e59a1f360a5f1ca9382ff53d9be941ef07f7b.1330539597.git.dvhart@linux.intel.com>
References: <8b7e59a1f360a5f1ca9382ff53d9be941ef07f7b.1330539597.git.dvhart@linux.intel.com>
In-Reply-To: <cover.1330539597.git.dvhart@linux.intel.com>
References: <cover.1330539597.git.dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For cases where boards with non-default clocks are not yet added to the kernel
or when the clock varies across hardware revisions, it is useful to be
able to specify the UART clock on the kernel command line.

Add the user_uartclk parameter and prefer it, if set, to the default and
board specific UART clock settings. Specify user_uartclock on the command-line
with "pch_uart.user_uartclk=48000000".

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
CC: Tomoya MORINAGA <tomoya.rohm@gmail.com>
CC: Feng Tang <feng.tang@intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Alan Cox <alan@linux.intel.com>
CC: linux-serial@vger.kernel.org
---
 drivers/tty/serial/pch_uart.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 3a2b0ae..105d982 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -290,6 +290,7 @@ static struct pch_uart_driver_data drv_dat[] = {
 static struct eg20t_port *pch_uart_ports[PCH_UART_NR];
 #endif
 static unsigned int default_baud = 9600;
+static unsigned int user_uartclk = 0;
 static const int trigger_level_256[4] = { 1, 64, 128, 224 };
 static const int trigger_level_64[4] = { 1, 16, 32, 56 };
 static const int trigger_level_16[4] = { 1, 4, 8, 14 };
@@ -300,6 +301,9 @@ static int pch_uart_get_uartclk(void)
 {
 	const char *cmp;
 
+	if (user_uartclk)
+		return user_uartclk;
+
 	cmp = dmi_get_system_info(DMI_BOARD_NAME);
 	if (cmp && strstr(cmp, "CM-iTC"))
 		return CMITC_UARTCLK;
@@ -1799,3 +1803,4 @@ module_exit(pch_uart_module_exit);
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Intel EG20T PCH UART PCI Driver");
 module_param(default_baud, uint, S_IRUGO);
+module_param(user_uartclk, uint, S_IRUGO);
-- 
1.7.6.5

