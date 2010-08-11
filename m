Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337Ab0HKRie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 13:38:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39591 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab0HKRic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 13:38:32 -0400
Date: Wed, 11 Aug 2010 10:36:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Peter Jones <pjones@redhat.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        scsi <linux-scsi@vger.kernel.org>
Subject: [PATCH -next] firmware: ibft depends on SCSI
Message-Id: <20100811103620.2d25d573.randy.dunlap@oracle.com>
In-Reply-To: <20100811140009.6ff33109.sfr@canb.auug.org.au>
References: <20100811140009.6ff33109.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Prevent build errors when SCSI is not enabled:

iscsi_ibft.c:(.init.text+0x548d): undefined reference to `iscsi_boot_create_initiator'
iscsi_ibft.c:(.init.text+0x54a9): undefined reference to `iscsi_boot_create_ethernet'
iscsi_ibft.c:(.init.text+0x54c5): undefined reference to `iscsi_boot_create_target'
iscsi_ibft.c:(.init.text+0x55ff): undefined reference to `iscsi_boot_destroy_kset'
iscsi_ibft.c:(.init.text+0x561e): undefined reference to `iscsi_boot_create_kset'
iscsi_ibft.c:(.exit.text+0xe2c): undefined reference to `iscsi_boot_destroy_kset'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Peter Jones <pjones@redhat.com>
Cc:	Konrad Rzeszutek Wilk <konrad@kernel.org>
---
 drivers/firmware/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20100811.orig/drivers/firmware/Kconfig
+++ linux-next-20100811/drivers/firmware/Kconfig
@@ -125,7 +125,7 @@ config ISCSI_IBFT_FIND
 config ISCSI_IBFT
 	tristate "iSCSI Boot Firmware Table Attributes module"
 	select ISCSI_BOOT_SYSFS
-	depends on ISCSI_IBFT_FIND
+	depends on ISCSI_IBFT_FIND && SCSI
 	default	n
 	help
 	  This option enables support for detection and exposing of iSCSI
