Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab1FVRI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 13:08:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:25394 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab1FVRIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 13:08:55 -0400
Date: Wed, 22 Jun 2011 10:06:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Margarita Olaya <magi@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] mfd: tps65912 needs MFD_CORE
Message-Id: <20110622100615.c79765ff.randy.dunlap@oracle.com>
In-Reply-To: <20110622163651.7ebc407c.sfr@canb.auug.org.au>
References: <20110622163651.7ebc407c.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090207.4E02219F.00E3:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

MFD_TPS65912 should select MFD_CORE so that mfd interfaces are
available to it.  This fixes a build error when MFD_CORE=m and
MFD_TPS65912=y (and no other TPS65912 kconfig symbols are enabled,
so no other select MFD_CORE was done).

drivers/built-in.o: In function `tps65912_device_exit':
(.text+0x61124): undefined reference to `mfd_remove_devices'
drivers/built-in.o: In function `tps65912_device_init':
(.text+0x61216): undefined reference to `mfd_add_devices'
drivers/built-in.o: In function `tps65912_device_init':
(.text+0x61240): undefined reference to `mfd_remove_devices'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/mfd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20110622.orig/drivers/mfd/Kconfig
+++ linux-next-20110622/drivers/mfd/Kconfig
@@ -173,6 +173,7 @@ config MFD_TPS6586X
 
 config MFD_TPS65912
 	bool "TPS65912 PMIC"
+	select MFD_CORE
 	depends on GPIOLIB
 
 config MFD_TPS65912_I2C
