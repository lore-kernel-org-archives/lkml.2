Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab2CIRxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 12:53:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:60400 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508Ab2CIRxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 12:53:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="119478339"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Feng Tang <feng.tang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Subject: [PATCH 4/5] pch_uart: Use existing default_baud in setup_console
Date: Fri,  9 Mar 2012 09:51:51 -0800
Message-Id: <d27cb1258d4a54c9b13ae03da4b90d95b0e678b6.1331315372.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <ae0029b9e1131467232389e4dfa630f50e159de0.1331315372.git.dvhart@linux.intel.com>
References: <ae0029b9e1131467232389e4dfa630f50e159de0.1331315372.git.dvhart@linux.intel.com>
In-Reply-To: <cover.1331315372.git.dvhart@linux.intel.com>
References: <cover.1331315372.git.dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than hardcode 9600, use the existing default_baud parameter (which
also defaults to 9600).

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
CC: Tomoya MORINAGA <tomoya.rohm@gmail.com>
CC: Feng Tang <feng.tang@intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Alan Cox <alan@linux.intel.com>
CC: linux-serial@vger.kernel.org
---
 drivers/tty/serial/pch_uart.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 46f6fbf..cca742b 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1566,7 +1566,7 @@ pch_console_write(struct console *co, const char *s, unsigned int count)
 static int __init pch_console_setup(struct console *co, char *options)
 {
 	struct uart_port *port;
-	int baud = 9600;
+	int baud = default_baud;
 	int bits = 8;
 	int parity = 'n';
 	int flow = 'n';
-- 
1.7.6.5

