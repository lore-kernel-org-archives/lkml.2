Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab1AYHov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 02:44:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:18971 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab1AYHou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 02:44:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,373,1291622400"; 
   d="scan'208,223";a="700292451"
Date: Tue, 25 Jan 2011 15:44:47 +0800
From: Yin Kangkai <kangkai.yin@linux.intel.com>
To: linux-serial <linux-serial@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        "Woodhouse, David" <david.woodhouse@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] serial: also set the uartclk value in resume after goes to
 highspeed
Message-ID: <20110125074447.GJ3315@kai-debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6f96e25fd4401b152adb9d91ebda0777f3532162 Mon Sep 17 00:00:00 2001
From: Yin Kangkai <kangkai.yin@intel.com>
Date: Mon, 24 Jan 2011 18:45:39 +0800
Subject: [PATCH] serial: also set the uartclk value in resume after goes to highspeed

For any reason if the NS16550A was not work in high speed mode (e.g. we hold
NS16550A from going to high speed mode in autoconfig_16550a()), now we are
resume from suspend, we should also set the uartclk to the correct
value. Otherwise it is still the old 1843200 and that will bring issues.

Signed-off-by: Yin Kangkai <kangkai.yin@intel.com>
---
 drivers/serial/8250.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 3e690da..e928e06 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2995,6 +2995,7 @@ void serial8250_resume_port(int line)
 		ns16550a_goto_highspeed(up);
 
 		serial_outp(up, UART_LCR, 0);
+		up->port.uartclk = 921600*16;
 	}
 	uart_resume_port(&serial8250_reg, &up->port);
 }
-- 
1.6.5
