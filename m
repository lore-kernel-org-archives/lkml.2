Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab1IACtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 22:49:36 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39545 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757479Ab1IACte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 22:49:34 -0400
Message-ID: <4E5EF3B4.90204@cs.wisc.edu>
Date: Wed, 31 Aug 2011 21:53:40 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        iscsi-driver@qlogic.com
Subject: Re: linux-next: Tree for Aug 30 (scsi/qla4xxx)
References: <20110830171605.168f29decb0558fa31e59210@canb.auug.org.au> <20110831134515.049f584b.rdunlap@xenotime.net>
In-Reply-To: <20110831134515.049f584b.rdunlap@xenotime.net>
Content-Type: multipart/mixed;
 boundary="------------010801060600060203050400"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010801060600060203050400
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 08/31/2011 03:45 PM, Randy Dunlap wrote:
> On Tue, 30 Aug 2011 17:16:05 +1000 Stephen Rothwell wrote:
> 
>> Hi all,
> 
> [Sorry about the delay.. slow build machine.
> Please ignore if this is already known/fixed.]
> 
> 
> (on i386)
> 
> ERROR: "iscsi_boot_create_target" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
> ERROR: "iscsi_boot_create_ethernet" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
> ERROR: "iscsi_boot_create_host_kset" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
> ERROR: "iscsi_boot_create_initiator" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
> ERROR: "iscsi_boot_destroy_kset" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
> 
> when CONFIG_ISCSI_BOOT_SYSFS is not enabled.
> 


We need the attached patch.

--------------010801060600060203050400
Content-Type: text/plain;
 name="0001-qla4xxx-select-iscsi-boot-sysfs-attrs.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-qla4xxx-select-iscsi-boot-sysfs-attrs.patch"

>From 64915c90128ebef61f076f58af3cba75288fae94 Mon Sep 17 00:00:00 2001
From: Mike Christie <michaelc@cs.wisc.edu>
Date: Wed, 31 Aug 2011 21:51:42 -0500
Subject: [PATCH] qla4xxx: select iscsi boot sysfs attrs

qla4xxx now uses iscsi_boot_sysfs to export the targets used
for boot to sysfs. It needs to select that config option
to make sure that module is also built.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/qla4xxx/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/Kconfig b/drivers/scsi/qla4xxx/Kconfig
index 2c33ce6..5b1aed4 100644
--- a/drivers/scsi/qla4xxx/Kconfig
+++ b/drivers/scsi/qla4xxx/Kconfig
@@ -2,6 +2,7 @@ config SCSI_QLA_ISCSI
 	tristate "QLogic ISP4XXX and ISP82XX host adapter family support"
 	depends on PCI && SCSI
 	select SCSI_ISCSI_ATTRS
+	select ISCSI_BOOT_SYSFS
 	---help---
 	This driver supports the QLogic 40xx (ISP4XXX) and 8022 (ISP82XX)
 	iSCSI host adapter family.
-- 
1.7.6


--------------010801060600060203050400--
