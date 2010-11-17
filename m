Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab0KQXjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 18:39:01 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:31452 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab0KQXi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 18:38:59 -0500
Date: Wed, 17 Nov 2010 15:38:46 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
        driverdevel <devel@driverdev.osuosl.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Ramesh Agarwal <ramesh.agarwal@intel.com>
Subject: [PATCH -next] staging: clearpad_tm1217 depends on INPUT
Message-Id: <20101117153846.072dc988.randy.dunlap@oracle.com>
In-Reply-To: <20101117140956.a8264c75.sfr@canb.auug.org.au>
References: <20101117140956.a8264c75.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

clearpad_tm1217 driver uses many input_() interfaces, so it should
depend on INPUT.

clearpad_tm1217.c:(.text+0xf19ac): undefined reference to `input_unregister_device'
clearpad_tm1217.c:(.text+0xf1b19): undefined reference to `input_event'
clearpad_tm1217.c:(.text+0xf1b31): undefined reference to `input_event'
clearpad_tm1217.c:(.text+0xf1bb4): undefined reference to `input_event'
clearpad_tm1217.c:(.text+0xf1bf2): undefined reference to `input_event'
drivers/built-in.o:clearpad_tm1217.c:(.text+0xf1c08): more undefined references to `input_event' follow
clearpad_tm1217.c:(.text+0xf1df3): undefined reference to `input_allocate_device'
clearpad_tm1217.c:(.text+0xf1eac): undefined reference to `input_set_abs_params'
clearpad_tm1217.c:(.text+0xf1ed1): undefined reference to `input_set_abs_params'
clearpad_tm1217.c:(.text+0xf1ed8): undefined reference to `input_register_device'
clearpad_tm1217.c:(.text+0xf2040): undefined reference to `input_unregister_device'
clearpad_tm1217.c:(.text+0xf204b): undefined reference to `input_free_device'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ramesh Agarwal <ramesh.agarwal@intel.com>
---
 drivers/staging/cptm1217/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20101117.orig/drivers/staging/cptm1217/Kconfig
+++ linux-next-20101117/drivers/staging/cptm1217/Kconfig
@@ -2,6 +2,7 @@ config TOUCHSCREEN_CLEARPAD_TM1217
 	tristate "Synaptics Clearpad TM1217"
 	depends on I2C
 	depends on GPIOLIB
+	depends on INPUT
 	help
 	  Say Y here if you have a Synaptics Clearpad TM1217 Controller
 
