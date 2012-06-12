Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab2FLB2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 21:28:49 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:57084 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752761Ab2FLB2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 21:28:47 -0400
Message-ID: <4FD69B42.4070709@xenotime.net>
Date: Mon, 11 Jun 2012 18:28:34 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>
CC: Leonid Froenchenko <lfroen@galileo.co.il>,
        Jarod Wilson <jarod@wilsonet.com>
Subject: [PATCH] staging/media/lirc: fix some lirc_bt829.c sparse warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix some sparse warnings in lirc_bt829.c:

drivers/staging/media/lirc/lirc_bt829.c:174:22: warning: non-ANSI function declaration of function 'poll_main'
drivers/staging/media/lirc/lirc_bt829.c:161:29: warning: Using plain integer as NULL pointer
drivers/staging/media/lirc/lirc_bt829.c:134:35: warning: Using plain integer as NULL pointer

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Leonid Froenchenko <lfroen@galileo.co.il>
Cc: Jarod Wilson <jarod@wilsonet.com>
---
 drivers/staging/media/lirc/lirc_bt829.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- lnx-35-rc2.orig/drivers/staging/media/lirc/lirc_bt829.c
+++ lnx-35-rc2/drivers/staging/media/lirc/lirc_bt829.c
@@ -131,7 +131,7 @@ int init_module(void)
 	atir_driver.minor       = -1;
 	atir_driver.code_length = 8;
 	atir_driver.sample_rate = 10;
-	atir_driver.data        = 0;
+	atir_driver.data        = NULL;
 	atir_driver.add_to_buf  = atir_add_to_buf;
 	atir_driver.set_use_inc = atir_set_use_inc;
 	atir_driver.set_use_dec = atir_set_use_dec;
@@ -158,7 +158,7 @@ void cleanup_module(void)
 static int atir_init_start(void)
 {
 	pci_addr_lin = ioremap(pci_addr_phys + DATA_PCI_OFF, 0x400);
-	if (pci_addr_lin == 0) {
+	if (pci_addr_lin == NULL) {
 		printk(KERN_INFO DRIVER_NAME ": pci mem must be mapped\n");
 		return 0;
 	}
@@ -171,7 +171,7 @@ static void cycle_delay(int cycle)
 }
 
 
-static int poll_main()
+static int poll_main(void)
 {
 	unsigned char status_high, status_low;
 
