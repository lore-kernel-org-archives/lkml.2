Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab1CUXbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:31:01 -0400
Received: from kroah.org ([198.145.64.141]:52579 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755681Ab1CUXRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:17:47 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:24 2011
Message-Id: <20110321230324.058743782@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:01:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg Kroah-Hartman <greg@kroah.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Yin Kangkai <kangkai.yin@linux.intel.com>
Subject: [23/78] serial: also set the uartclk value in resume after goes to highspeed
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yin Kangkai <kangkai.yin@linux.intel.com>

commit 95926d2db6256e08d06b753752a0d903a0580acc upstream.

For any reason if the NS16550A was not work in high speed mode (e.g. we hold
NS16550A from going to high speed mode in autoconfig_16550a()), now we are
resume from suspend, we should also set the uartclk to the correct
value. Otherwise it is still the old 1843200 and that will bring issues.

CC: Greg Kroah-Hartman <greg@kroah.com>
CC: David Woodhouse <dwmw2@infradead.org>
CC: linux-kernel@vger.kernel.org
Signed-off-by: Yin Kangkai <kangkai.yin@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/tty/serial/8250.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -3036,6 +3036,7 @@ void serial8250_resume_port(int line)
 		serial_outp(up, 0x04, tmp);
 
 		serial_outp(up, UART_LCR, 0);
+		up->port.uartclk = 921600*16;
 	}
 	uart_resume_port(&serial8250_reg, &up->port);
 }


