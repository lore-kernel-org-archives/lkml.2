Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab0JNEFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 00:05:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49154 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab0JNEFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 00:05:12 -0400
Date: Wed, 13 Oct 2010 18:07:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Peter Jones <pjones@redhat.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: [PATCH -next] ibft: fix kconfig dependencies
Message-Id: <20101013180716.6cf5a80f.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kconfig dependency warning to satisfy dependencies:

warning: (BE2ISCSI && SCSI_LOWLEVEL && PCI && SCSI && NET || ISCSI_IBFT && ISCSI_IBFT_FIND && SCSI) selects ISCSI_BOOT_SYSFS which has unmet direct dependencies (SCSI_LOWLEVEL && SCSI)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Peter Jones <pjones@redhat.com>
Cc:	Konrad Rzeszutek Wilk <konrad@kernel.org>
---
 drivers/firmware/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20101013.orig/drivers/firmware/Kconfig
+++ linux-next-20101013/drivers/firmware/Kconfig
@@ -125,7 +125,7 @@ config ISCSI_IBFT_FIND
 config ISCSI_IBFT
 	tristate "iSCSI Boot Firmware Table Attributes module"
 	select ISCSI_BOOT_SYSFS
-	depends on ISCSI_IBFT_FIND && SCSI
+	depends on ISCSI_IBFT_FIND && SCSI && SCSI_LOWLEVEL
 	default	n
 	help
 	  This option enables support for detection and exposing of iSCSI
