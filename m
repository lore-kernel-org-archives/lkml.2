Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030253Ab2B2S0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 13:26:23 -0500
Received: from mga03.intel.com ([143.182.124.21]:9480 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757400Ab2B2S0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 13:26:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="112894826"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Feng Tang <feng.tang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Subject: [PATCH 4/4] pch_uart: Use existing default_baud in setup_console
Date: Wed, 29 Feb 2012 10:24:47 -0800
Message-Id: <8f474d0210f235a588bcd29a91c83d21596b043c.1330539597.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <8b7e59a1f360a5f1ca9382ff53d9be941ef07f7b.1330539597.git.dvhart@linux.intel.com>
References: <8b7e59a1f360a5f1ca9382ff53d9be941ef07f7b.1330539597.git.dvhart@linux.intel.com>
In-Reply-To: <cover.1330539597.git.dvhart@linux.intel.com>
References: <cover.1330539597.git.dvhart@linux.intel.com>
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
index 105d982..21af194b 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1516,7 +1516,7 @@ pch_console_write(struct console *co, const char *s, unsigned int count)
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

