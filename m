Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618Ab1ISXK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 19:10:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55319 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab1ISXKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 19:10:25 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Sep 19 16:08:33 2011
Message-Id: <20110919230833.363314137@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 19 Sep 2011 16:05:10 -0700
From: Greg KH <gregkh@suse.de>
To: torvalds@linux-foundation.org, Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Andiry Xu <andiry.xu@amd.com>
Subject: [patch 1/3] staging: fix comedi build when ISA_DMA_API is enabled but COMEDI_PCI is not enabled
In-Reply-To: <20110919230920.GA6555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build when CONFIG_ISA_DMA_API is enabled but
CONFIG_COMEDI_PCI[_DRIVERS] is not enabled.
Fixes these build errors:

drivers/staging/comedi/drivers/ni_labpc.c: In function 'labpc_ai_cmd':
drivers/staging/comedi/drivers/ni_labpc.c:1351: error: implicit declaration of function 'labpc_suggest_transfer_size'
drivers/staging/comedi/drivers/ni_labpc.c: At top level:
drivers/staging/comedi/drivers/ni_labpc.c:1802: error: conflicting types for 'labpc_suggest_transfer_size'
drivers/staging/comedi/drivers/ni_labpc.c:1351: note: previous implicit declaration of 'labpc_suggest_transfer_size' was here

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/comedi/drivers/ni_labpc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -241,8 +241,10 @@ static int labpc_eeprom_write_insn(struc
 				   struct comedi_insn *insn,
 				   unsigned int *data);
 static void labpc_adc_timing(struct comedi_device *dev, struct comedi_cmd *cmd);
-#ifdef CONFIG_COMEDI_PCI
+#ifdef CONFIG_ISA_DMA_API
 static unsigned int labpc_suggest_transfer_size(struct comedi_cmd cmd);
+#endif
+#ifdef CONFIG_COMEDI_PCI
 static int labpc_find_device(struct comedi_device *dev, int bus, int slot);
 #endif
 static int labpc_dio_mem_callback(int dir, int port, int data,


