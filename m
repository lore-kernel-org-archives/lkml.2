Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab0KLWrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 17:47:48 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:42801 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab0KLWrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 17:47:46 -0500
Date: Fri, 12 Nov 2010 14:47:02 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
        driverdevel <devel@driverdev.osuosl.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        naveen.gaddipati@stericsson.com, js.ha@stericsson.com
Subject: [PATCH -next] staging: fix ste_rmi4 build, depends on INPUT
Message-Id: <20101112144702.117505ee.randy.dunlap@oracle.com>
In-Reply-To: <20101111125655.15fa7188.sfr@canb.auug.org.au>
References: <20101111125655.15fa7188.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

The synaptics_i2c_rmi4 driver uses input_*() interfaces,
so it should depend on INPUT to fix its build errors:

ERROR: "input_event" [drivers/staging/ste_rmi4/synaptics_i2c_rmi4.ko] undefined!
ERROR: "input_free_device" [drivers/staging/ste_rmi4/synaptics_i2c_rmi4.ko] undefined!
ERROR: "input_register_device" [drivers/staging/ste_rmi4/synaptics_i2c_rmi4.ko] undefined!
ERROR: "input_set_abs_params" [drivers/staging/ste_rmi4/synaptics_i2c_rmi4.ko] undefined!
ERROR: "input_allocate_device" [drivers/staging/ste_rmi4/synaptics_i2c_rmi4.ko] undefined!
ERROR: "input_unregister_device" [drivers/staging/ste_rmi4/synaptics_i2c_rmi4.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: naveen.gaddipati@stericsson.com, js.ha@stericsson.com
---
 drivers/staging/ste_rmi4/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20101111.orig/drivers/staging/ste_rmi4/Kconfig
+++ linux-next-20101111/drivers/staging/ste_rmi4/Kconfig
@@ -1,6 +1,6 @@
 config TOUCHSCREEN_SYNAPTICS_I2C_RMI4
 	tristate "Synaptics i2c rmi4 touchscreen"
-	depends on I2C
+	depends on I2C && INPUT
 	help
 	  Say Y here if you have a Synaptics RMI4 and
 	  want to enable support for the built-in touchscreen.
