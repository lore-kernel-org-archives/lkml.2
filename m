Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab2FEQqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 12:46:17 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:43054 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754285Ab2FEQqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 12:46:15 -0400
Message-ID: <4FCE37CF.90902@xenotime.net>
Date: Tue, 05 Jun 2012 09:46:07 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org
CC: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: serial: fix serial_txx9.c build warning/typo
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix kconfig symbol test to use "defined":

drivers/tty/serial/serial_txx9.c: warning: "CONFIG_CONSOLE_POLL" is not defined [-Wundef]

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/tty/serial/serial_txx9.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-35-rc1.orig/drivers/tty/serial/serial_txx9.c
+++ lnx-35-rc1/drivers/tty/serial/serial_txx9.c
@@ -466,7 +466,7 @@ static void serial_txx9_break_ctl(struct
 	spin_unlock_irqrestore(&up->port.lock, flags);
 }
 
-#if defined(CONFIG_SERIAL_TXX9_CONSOLE) || (CONFIG_CONSOLE_POLL)
+#if defined(CONFIG_SERIAL_TXX9_CONSOLE) || defined(CONFIG_CONSOLE_POLL)
 /*
  *	Wait for transmitter & holding register to empty
  */
