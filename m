Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab0G2VGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 17:06:41 -0400
Received: from mail96.messagelabs.com ([216.82.254.19]:4580 "EHLO
	mail96.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab0G2VGj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 17:06:39 -0400
X-VirusChecked: Checked
X-Env-Sender: jayamohank@serverengines.com
X-Msg-Ref: server-7.tower-96.messagelabs.com!1280437595!63281270!1
X-StarScan-Version: 6.2.4; banners=-,-,-
X-Originating-IP: [68.165.1.68]
To: "Randy Dunlap" <randy.dunlap@oracle.com>,
        "Stephen Rothwell" <sfr@canb.auug.org.au>,
        scsi <linux-scsi@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        jejbscsi <james.bottomley@suse.de>
From: "Jayamohan Kalickal" <jayamohank@serverengines.com>
Organization: Serverengines LLC
Subject: Re: [PATCH -next] scsi: be2iscsi needs ISCSI_BOOT_SYSFS
In-Reply-To: 20100729101609.965dbe48.randy.dunlap@oracle.com
Message-ID: <20100729210633.19ce36e7@mailhost.serverengines.com>
Date: Thu, 29 Jul 2010 14:06:33 -0700
X-User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100524 Red
	Hat/3.6.4-4.el6 Firefox/3.6.4
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_____  
From: Randy Dunlap [mailto:randy.dunlap@oracle.com]
To: Stephen Rothwell [mailto:sfr@canb.auug.org.au], scsi [mailto:linux-scsi@vger.kernel.org], Jayamohan Kallickal [mailto:jayamohank@serverengines.com]
Cc: linux-next@vger.kernel.org, LKML [mailto:linux-kernel@vger.kernel.org], jejbscsi [mailto:james.bottomley@suse.de]
Sent: Thu, 29 Jul 2010 10:16:09 -0700
Subject: [PATCH -next] scsi: be2iscsi needs ISCSI_BOOT_SYSFS

From: Randy Dunlap <randy.dunlap@oracle.com>

be2iscsi uses iscsi_boot_*() interfaces, so it should ensure that
ISCSI_BOOT_SYSFS is enabled.

ERROR: "iscsi_boot_create_target" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!
ERROR: "iscsi_boot_create_ethernet" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!
ERROR: "iscsi_boot_create_host_kset" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!
ERROR: "iscsi_boot_create_initiator" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!
ERROR: "iscsi_boot_destroy_kset" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>


Acked-by: Jayamohan Kallickal <jayamohank@serverengines.com> 
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

___________________________________________________________________________________
This message, together with any attachment(s), contains confidential and proprietary information of
ServerEngines Corporation and is intended only for the designated recipient(s) named above. Any unauthorized
review, printing, retention, copying, disclosure or distribution is strictly prohibited.  If you are not the
intended recipient of this message, please immediately advise the sender by reply email message and
delete all copies of this message and any attachment(s). Thank you.

