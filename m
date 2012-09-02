Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab2IBRNc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 13:13:32 -0400
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:53041 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754261Ab2IBRNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 13:13:30 -0400
Message-ID: <504393A7.8040007@xenotime.net>
Date: Sun, 02 Sep 2012 10:13:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Subject: [PATCH] net/can:  rename peak_usb dump_mem function
References: <1346577700-8156-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1346577700-8156-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Rename generic-sounding function dump_mem() to pcan_dump_mem()
so that it does not conflict with the dump_mem() function in
arch/sh/include/asm/kdebug.h.

drivers/net/can/usb/peak_usb/pcan_usb_core.c: error: conflicting types for 'dump_mem':  => 56:6
drivers/net/can/usb/peak_usb/pcan_usb_core.h: error: conflicting types for 'dump_mem':  => 134:6

Not tested.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephane Grosjean <s.grosjean@peak-system.com>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c |    2 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- lnx-36-rc4.orig/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ lnx-36-rc4/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -53,7 +53,7 @@ static struct peak_usb_adapter *peak_usb
  * dump memory
  */
 #define DUMP_WIDTH	16
-void dump_mem(char *prompt, void *p, int l)
+void pcan_dump_mem(char *prompt, void *p, int l)
 {
 	pr_info("%s dumping %s (%d bytes):\n",
 		PCAN_USB_DRIVER_NAME, prompt ? prompt : "memory", l);
--- lnx-36-rc4.orig/drivers/net/can/usb/peak_usb/pcan_usb_core.h
+++ lnx-36-rc4/drivers/net/can/usb/peak_usb/pcan_usb_core.h
@@ -131,7 +131,7 @@ struct peak_usb_device {
 	struct peak_usb_device *next_siblings;
 };
 
-void dump_mem(char *prompt, void *p, int l);
+void pcan_dump_mem(char *prompt, void *p, int l);
 
 /* common timestamp management */
 void peak_usb_init_time_ref(struct peak_time_ref *time_ref,
