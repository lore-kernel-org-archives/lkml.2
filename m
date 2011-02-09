Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab1BIDes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 22:34:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:59884 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756198Ab1BIDeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 22:34:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,445,1291622400"; 
   d="scan'208";a="885709022"
From: Yin Kangkai <kangkai.yin@linux.intel.com>
To: Greg Kroah-Hartman <greg@kroah.com>,
        linux-serial <linux-serial@vger.kernel.org>
Cc: Yin Kangkai <kangkai.yin@linux.intel.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH resend 1/2] serial: also set the uartclk value in resume after goes to highspeed
Date: Wed,  9 Feb 2011 11:34:20 +0800
Message-Id: <1297222460-20764-1-git-send-email-kangkai.yin@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20110125074447.GJ3315@kai-debian>
References: <20110125074447.GJ3315@kai-debian>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For any reason if the NS16550A was not work in high speed mode (e.g. we hold
NS16550A from going to high speed mode in autoconfig_16550a()), now we are
resume from suspend, we should also set the uartclk to the correct
value. Otherwise it is still the old 1843200 and that will bring issues.

CC: Greg Kroah-Hartman <greg@kroah.com>
CC: David Woodhouse <dwmw2@infradead.org>
CC: linux-kernel@vger.kernel.org
CC: stable@kernel.org
Signed-off-by: Yin Kangkai <kangkai.yin@linux.intel.com>
---
 drivers/tty/serial/8250.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index 3975df6..c10a6a9 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -3036,6 +3036,7 @@ void serial8250_resume_port(int line)
 		serial_outp(up, 0x04, tmp);
 
 		serial_outp(up, UART_LCR, 0);
+		up->port.uartclk = 921600*16;
 	}
 	uart_resume_port(&serial8250_reg, &up->port);
 }
-- 
1.7.2.3

