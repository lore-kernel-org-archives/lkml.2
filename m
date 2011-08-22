Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab1HVSNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 14:13:20 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:56325 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752435Ab1HVSNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 14:13:17 -0400
Date: Mon, 22 Aug 2011 11:13:14 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>,
        akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        gregkh <greg@kroah.com>, an Abbott <abbotti@mev.co.uk>,
        ori Hess <fmhess@users.sourceforge.net>
Subject: [PATCH -next] staging: fix comedi build when COMEDI_PCI is not
 enabled
Message-Id: <20110822111314.bf7a526f.rdunlap@xenotime.net>
In-Reply-To: <20110822145304.980529cb921e5f1321c622da@canb.auug.org.au>
References: <20110822145304.980529cb921e5f1321c622da@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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
 drivers/staging/comedi/drivers/ni_labpc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux-next-20110822.orig/drivers/staging/comedi/drivers/ni_labpc.c
+++ linux-next-20110822/drivers/staging/comedi/drivers/ni_labpc.c
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
