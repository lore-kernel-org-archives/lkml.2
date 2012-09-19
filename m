Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928Ab2ISSQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 14:16:43 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:55733 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932868Ab2ISSQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 14:16:24 -0400
Message-ID: <505A0BCF.5040905@xenotime.net>
Date: Wed, 19 Sep 2012 11:15:43 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: [PATCH -next] ata: fix sata_highbank.c build errors
References: <20120919162643.907ddda75e198f060e4e83fe@canb.auug.org.au>
In-Reply-To: <20120919162643.907ddda75e198f060e4e83fe@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build errors in sata_highbank.c by also building libahci.o.
Fixes these build errors:

drivers/built-in.o: In function `ahci_highbank_hardreset':
sata_highbank.c:(.text+0x1edc9a): undefined reference to `ahci_stop_engine'
sata_highbank.c:(.text+0x1edfab): undefined reference to `ahci_start_engine'
sata_highbank.c:(.text+0x1edfd5): undefined reference to `ahci_dev_classify'
drivers/built-in.o: In function `ahci_highbank_resume':
sata_highbank.c:(.text+0x1ee0af): undefined reference to `ahci_reset_controller'
sata_highbank.c:(.text+0x1ee0e1): undefined reference to `ahci_init_controller'
drivers/built-in.o: In function `ahci_highbank_probe':
sata_highbank.c:(.init.text+0xc577): undefined reference to `ahci_save_initial_config'
sata_highbank.c:(.init.text+0xc5ca): undefined reference to `ahci_set_em_messages'
sata_highbank.c:(.init.text+0xc630): undefined reference to `ahci_ignore_sss'
sata_highbank.c:(.init.text+0xc660): undefined reference to `ahci_reset_em'
sata_highbank.c:(.init.text+0xc72f): undefined reference to `ahci_reset_controller'
sata_highbank.c:(.init.text+0xc75a): undefined reference to `ahci_init_controller'
sata_highbank.c:(.init.text+0xc774): undefined reference to `ahci_print_info'
sata_highbank.c:(.init.text+0xc77c): undefined reference to `ahci_interrupt'
drivers/built-in.o:(.data+0x1d5ec): undefined reference to `ahci_ops'
drivers/built-in.o:(.data+0x1d690): undefined reference to `ahci_shost_attrs'
drivers/built-in.o:(.data+0x1d694): undefined reference to `ahci_sdev_attrs'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
---
 drivers/ata/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20120919.orig/drivers/ata/Makefile
+++ linux-next-20120919/drivers/ata/Makefile
@@ -9,7 +9,7 @@ obj-$(CONFIG_SATA_FSL)		+= sata_fsl.o
 obj-$(CONFIG_SATA_INIC162X)	+= sata_inic162x.o
 obj-$(CONFIG_SATA_SIL24)	+= sata_sil24.o
 obj-$(CONFIG_SATA_DWC)		+= sata_dwc_460ex.o
-obj-$(CONFIG_SATA_HIGHBANK)	+= sata_highbank.o
+obj-$(CONFIG_SATA_HIGHBANK)	+= sata_highbank.o libahci.o
 
 # SFF w/ custom DMA
 obj-$(CONFIG_PDC_ADMA)		+= pdc_adma.o
