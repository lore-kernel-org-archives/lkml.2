Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab2CIRxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 12:53:17 -0500
Received: from mga03.intel.com ([143.182.124.21]:59515 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405Ab2CIRxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 12:53:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="116921408"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Feng Tang <feng.tang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Subject: [PATCH 3/5] pch_uart: Add user_uartclk parameter
Date: Fri,  9 Mar 2012 09:51:50 -0800
Message-Id: <be97382520873accbb2eebe8a869fe04c730869d.1331315372.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <ae0029b9e1131467232389e4dfa630f50e159de0.1331315372.git.dvhart@linux.intel.com>
References: <ae0029b9e1131467232389e4dfa630f50e159de0.1331315372.git.dvhart@linux.intel.com>
In-Reply-To: <cover.1331315372.git.dvhart@linux.intel.com>
References: <cover.1331315372.git.dvhart@linux.intel.com>
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
index 88a1be0..46f6fbf 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -295,6 +295,7 @@ static struct pch_uart_driver_data drv_dat[] = {
 static struct eg20t_port *pch_uart_ports[PCH_UART_NR];
 #endif
 static unsigned int default_baud = 9600;
+static unsigned int user_uartclk = 0;
 static const int trigger_level_256[4] = { 1, 64, 128, 224 };
 static const int trigger_level_64[4] = { 1, 16, 32, 56 };
 static const int trigger_level_16[4] = { 1, 4, 8, 14 };
@@ -372,6 +373,9 @@ static int pch_uart_get_uartclk(void)
 {
 	const char *cmp;
 
+	if (user_uartclk)
+		return user_uartclk;
+
 	cmp = dmi_get_system_info(DMI_BOARD_NAME);
 	if (cmp && strstr(cmp, "CM-iTC"))
 		return CMITC_UARTCLK;
@@ -1860,3 +1864,4 @@ module_exit(pch_uart_module_exit);
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Intel EG20T PCH UART PCI Driver");
 module_param(default_baud, uint, S_IRUGO);
+module_param(user_uartclk, uint, S_IRUGO);
-- 
1.7.6.5

