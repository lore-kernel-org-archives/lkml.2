Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab0G2RQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 13:16:58 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64294 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab0G2RQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 13:16:56 -0400
Date: Thu, 29 Jul 2010 10:16:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>,
        Jayamohan Kallickal <jayamohank@serverengines.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        jejbscsi <james.bottomley@suse.de>
Subject: [PATCH -next] scsi: be2iscsi needs ISCSI_BOOT_SYSFS
Message-Id: <20100729101609.965dbe48.randy.dunlap@oracle.com>
In-Reply-To: <20100729143211.9e7edaed.sfr@canb.auug.org.au>
References: <20100729143211.9e7edaed.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C51B77F.0225:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

be2iscsi uses iscsi_boot_*() interfaces, so it should ensure that
ISCSI_BOOT_SYSFS is enabled.

ERROR: "iscsi_boot_create_target" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!
ERROR: "iscsi_boot_create_ethernet" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!
ERROR: "iscsi_boot_create_host_kset" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!
ERROR: "iscsi_boot_create_initiator" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!
ERROR: "iscsi_boot_destroy_kset" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/be2iscsi/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20100729.orig/drivers/scsi/be2iscsi/Kconfig
+++ linux-next-20100729/drivers/scsi/be2iscsi/Kconfig
@@ -2,6 +2,7 @@ config BE2ISCSI
 	tristate "ServerEngines' 10Gbps iSCSI - BladeEngine 2"
 	depends on PCI && SCSI && NET
 	select SCSI_ISCSI_ATTRS
+	select ISCSI_BOOT_SYSFS
 
 	help
 	This driver implements the iSCSI functionality for ServerEngines'
---
