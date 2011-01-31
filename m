Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab1AaVMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 16:12:32 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:43810 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab1AaVMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 16:12:30 -0500
Date: Mon, 31 Jan 2011 13:11:28 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de, wei_wang@realsil.com.cn
Subject: [PATCH -next] staging: fix rts_pstor build errors
Message-Id: <20110131131128.0154c518.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix multiple rts_pstor build errors.

When CONFIG_PCI is not enabled:

drivers/staging/rts_pstor/rtsx.c: In function 'rtsx_acquire_irq':
drivers/staging/rts_pstor/rtsx.c:324: error: implicit declaration of function 'pci_intx'
drivers/staging/rts_pstor/rtsx.c: In function 'rtsx_read_pci_cfg_byte':
drivers/staging/rts_pstor/rtsx.c:336: error: implicit declaration of function 'pci_get_domain_bus_and_slot'
drivers/staging/rts_pstor/rtsx.c:336: warning: assignment makes pointer from integer without a cast
drivers/staging/rts_pstor/rtsx.c: In function 'rtsx_shutdown':
drivers/staging/rts_pstor/rtsx.c:462: error: implicit declaration of function 'pci_disable_msi'
drivers/staging/rts_pstor/rtsx.c: In function 'rtsx_probe':
drivers/staging/rts_pstor/rtsx.c:981: error: implicit declaration of function 'pci_enable_msi'

When CONFIG_SCSI is not enabled:

In file included from drivers/staging/rts_pstor/rtsx.h:45,
                 from drivers/staging/rts_pstor/rtsx.c:28:
include/scsi/scsi_cmnd.h:27:25: warning: "BLK_MAX_CDB" is not defined
include/scsi/scsi_cmnd.h:28:3: error: #error MAX_COMMAND_SIZE can not be bigger than BLK_MAX_CDB
In file included from drivers/staging/rts_pstor/rtsx.h:45,
                 from drivers/staging/rts_pstor/rtsx.c:28:
include/scsi/scsi_cmnd.h: In function 'scsi_bidi_cmnd':
include/scsi/scsi_cmnd.h:184: error: implicit declaration of function 'blk_bidi_rq'
include/scsi/scsi_cmnd.h:185: error: dereferencing pointer to incomplete type
include/scsi/scsi_cmnd.h: In function 'scsi_in':
include/scsi/scsi_cmnd.h:191: error: dereferencing pointer to incomplete type
include/scsi/scsi_cmnd.h: In function 'scsi_get_lba':  CC      drivers/gpu/drm/nouveau/nv04_tv.o

include/scsi/scsi_cmnd.h:269: error: implicit declaration of function 'blk_rq_pos'
In file included from drivers/staging/rts_pstor/rtsx.h:48,
                 from drivers/staging/rts_pstor/rtsx.c:28:
include/scsi/scsi_eh.h: At top level:
include/scsi/scsi_eh.h:84: error: 'BLK_MAX_CDB' undeclared here (not in a function)
drivers/staging/rts_pstor/rtsx.c: In function 'slave_configure':
drivers/staging/rts_pstor/rtsx.c:107: error: implicit declaration of function 'blk_queue_dma_alignment'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: wei_wang@realsil.com.cn
---
 drivers/staging/rts_pstor/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20110131.orig/drivers/staging/rts_pstor/Kconfig
+++ linux-next-20110131/drivers/staging/rts_pstor/Kconfig
@@ -1,5 +1,6 @@
 config RTS_PSTOR
 	tristate "RealTek PCI-E Card Reader support"
+	depends on PCI && SCSI
 	help
 	  Say Y here to include driver code to support the Realtek
 	  PCI-E card readers.
