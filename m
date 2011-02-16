Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab1BPWbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:31:33 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:60782 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab1BPWbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:31:31 -0500
Date: Wed, 16 Feb 2011 14:31:02 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Hong Liu <hong.liu@intel.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
Subject: [PATCH -next] platform/x86: intel_mid_powerbutton needs INPUT
Message-Id: <20110216143102.04bc6754.randy.dunlap@oracle.com>
In-Reply-To: <20110216165321.c8238ed5.sfr@canb.auug.org.au>
References: <20110216165321.c8238ed5.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D5C5033.0004:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

intel_mid_powerbtn.c uses input interfaces, so it should depend
on INPUT to fix build errors when CONFIG_INPUT is not enabled:

intel_mid_powerbtn.c:(.text+0x56ca8f): undefined reference to `input_event'
intel_mid_powerbtn.c:(.devinit.text+0x2e7b4): undefined reference to `input_allocate_device'
intel_mid_powerbtn.c:(.devinit.text+0x2e7ff): undefined reference to `input_set_capability'
intel_mid_powerbtn.c:(.devinit.text+0x2e84a): undefined reference to `input_register_device'
intel_mid_powerbtn.c:(.devinit.text+0x2e88b): undefined reference to `input_free_device'
intel_mid_powerbtn.c:(.devexit.text+0x42f0): undefined reference to `input_unregister_device'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Hong Liu <hong.liu@intel.com>
---
 drivers/platform/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20110216.orig/drivers/platform/x86/Kconfig
+++ linux-next-20110216/drivers/platform/x86/Kconfig
@@ -607,7 +607,7 @@ config INTEL_MFLD_THERMAL
 
 config INTEL_MID_POWER_BUTTON
 	tristate "power button driver for Intel MID platforms"
-	depends on INTEL_SCU_IPC
+	depends on INTEL_SCU_IPC && INPUT
 	help
 	  This driver handles the power button on the Intel MID platforms.
 
