Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab1IHXNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:13:07 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:49513 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752355Ab1IHXM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:12:59 -0400
Message-ID: <4E68E7F9.4020906@xenotime.net>
Date: Thu, 08 Sep 2011 09:06:17 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Greg KH <gregkh@suse.de>, driverdevel <devel@driverdev.osuosl.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>
Subject: [PATCH] staging: fix comedi build when ISA_DMA_API is enabled but
 COMEDI_PCI is not enabled
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
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
---

Greg, I had previously said that this patch was not needed since
you had merged a larger patch, but I had another build error which
this patch fixes, so it is now needed in mainline.

 drivers/staging/comedi/drivers/ni_labpc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- lnx-31-rc5.orig/drivers/staging/comedi/drivers/ni_labpc.c
+++ lnx-31-rc5/drivers/staging/comedi/drivers/ni_labpc.c
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
