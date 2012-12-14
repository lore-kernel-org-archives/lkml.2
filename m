Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab2LNIuP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 03:50:15 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:60814 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab2LNIuN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 03:50:13 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] mfd: lp8788: fix config dependency problem on IRQ
Thread-Topic: [PATCH] mfd: lp8788: fix config dependency problem on IRQ
Thread-Index: Ac3Z2ANDgO/xLCnDSJq+zhjhShPFRg==
Date: Fri, 14 Dec 2012 08:50:06 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0D03A@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 LP8788 uses IRQ APIs which depend on GENERIC_HARDIRQS.
 So this dependency should be added in Kconfig.

 This error occurs in case of doing 'make ARCH=s390 allyesconfig'.
 This patch enables building lp8788 mfd driver only when GENERIC_HARDIRQS
 are configured.

All error/warnings:

drivers/mfd/lp8788-irq.c:66:38: warning: 'struct irq_data' declared inside param
eter list [enabled by default]
drivers/mfd/lp8788-irq.c:66:38: warning: its scope is only this definition or de
claration, which is probably not what you want [enabled by default]
drivers/mfd/lp8788-irq.c: In function 'lp8788_irq_enable':
drivers/mfd/lp8788-irq.c:68:9: error: implicit declaration of function 'irq_data
_get_irq_chip_data' [-Werror=implicit-function-declaration]
drivers/mfd/lp8788-irq.c:68:33: warning: initialization makes pointer from integ
er without a cast [enabled by default]
drivers/mfd/lp8788-irq.c:69:20: error: dereferencing pointer to incomplete type
drivers/mfd/lp8788-irq.c: At top level:
drivers/mfd/lp8788-irq.c:72:39: warning: 'struct irq_data' declared inside param
eter list [enabled by default]
drivers/mfd/lp8788-irq.c: In function 'lp8788_irq_disable':
drivers/mfd/lp8788-irq.c:74:33: warning: initialization makes pointer from integ
er without a cast [enabled by default]
drivers/mfd/lp8788-irq.c:75:20: error: dereferencing pointer to incomplete type
drivers/mfd/lp8788-irq.c: At top level:
drivers/mfd/lp8788-irq.c:78:40: warning: 'struct irq_data' declared inside param
eter list [enabled by default]
drivers/mfd/lp8788-irq.c: In function 'lp8788_irq_bus_lock':
drivers/mfd/lp8788-irq.c:80:33: warning: initialization makes pointer from integ
er without a cast [enabled by default]
drivers/mfd/lp8788-irq.c: At top level:
drivers/mfd/lp8788-irq.c:85:47: warning: 'struct irq_data' declared inside param
eter list [enabled by default]
drivers/mfd/lp8788-irq.c: In function 'lp8788_irq_bus_sync_unlock':
drivers/mfd/lp8788-irq.c:87:33: warning: initialization makes pointer from integ
er without a cast [enabled by default]
drivers/mfd/lp8788-irq.c:88:31: error: dereferencing pointer to incomplete type
drivers/mfd/lp8788-irq.c: At top level:
drivers/mfd/lp8788-irq.c:100:15: error: variable 'lp8788_irq_chip' has initializ
er but incomplete type
drivers/mfd/lp8788-irq.c:101:2: error: unknown field 'name' specified in initial
izer
drivers/mfd/lp8788-irq.c:101:2: warning: excess elements in struct initializer [
enabled by default]
drivers/mfd/lp8788-irq.c:101:2: warning: (near initialization for 'lp8788_irq_ch
ip') [enabled by default]
drivers/mfd/lp8788-irq.c:102:2: error: unknown field 'irq_enable' specified in i
nitializer
drivers/mfd/lp8788-irq.c:102:2: warning: excess elements in struct initializer [
enabled by default]
drivers/mfd/lp8788-irq.c:102:2: warning: (near initialization for 'lp8788_irq_ch
ip') [enabled by default]
drivers/mfd/lp8788-irq.c:103:2: error: unknown field 'irq_disable' specified in 
initializer
drivers/mfd/lp8788-irq.c:103:2: warning: excess elements in struct initializer [
enabled by default]
drivers/mfd/lp8788-irq.c:103:2: warning: (near initialization for 'lp8788_irq_ch
ip') [enabled by default]
drivers/mfd/lp8788-irq.c:104:2: error: unknown field 'irq_bus_lock' specified in
 initializer
drivers/mfd/lp8788-irq.c:104:2: warning: excess elements in struct initializer [
enabled by default]
drivers/mfd/lp8788-irq.c:104:2: warning: (near initialization for 'lp8788_irq_ch
ip') [enabled by default]
drivers/mfd/lp8788-irq.c:105:2: error: unknown field 'irq_bus_sync_unlock' speci
fied in initializer
drivers/mfd/lp8788-irq.c:105:2: warning: excess elements in struct initializer [
enabled by default]
drivers/mfd/lp8788-irq.c:105:2: warning: (near initialization for 'lp8788_irq_ch
ip') [enabled by default]
drivers/mfd/lp8788-irq.c: In function 'lp8788_irq_handler':
drivers/mfd/lp8788-irq.c:125:4: error: implicit declaration of function 'handle_
nested_irq' [-Werror=implicit-function-declaration]
drivers/mfd/lp8788-irq.c:125:4: error: implicit declaration of function 'irq_fin
d_mapping' [-Werror=implicit-function-declaration]
drivers/mfd/lp8788-irq.c: In function 'lp8788_irq_map':
drivers/mfd/lp8788-irq.c:139:2: error: implicit declaration of function 'irq_set
_chip_data' [-Werror=implicit-function-declaration]
drivers/mfd/lp8788-irq.c:140:2: error: implicit declaration of function 'irq_set
_chip_and_handler' [-Werror=implicit-function-declaration]
drivers/mfd/lp8788-irq.c:140:39: error: 'handle_edge_irq' undeclared (first use 
in this function)
drivers/mfd/lp8788-irq.c:140:39: note: each undeclared identifier is reported on
ly once for each function it appears in
drivers/mfd/lp8788-irq.c:141:2: error: implicit declaration of function 'irq_set
_nested_thread' [-Werror=implicit-function-declaration]
drivers/mfd/lp8788-irq.c:146:2: error: implicit declaration of function 'irq_set
_noprobe' [-Werror=implicit-function-declaration]
drivers/mfd/lp8788-irq.c: In function 'lp8788_irq_init':
drivers/mfd/lp8788-irq.c:171:2: error: implicit declaration of function 'irq_dom
ain_add_linear' [-Werror=implicit-function-declaration]
drivers/mfd/lp8788-irq.c:171:15: warning: assignment makes pointer from integer 
without a cast [enabled by default]
cc1: some warnings being treated as errors


Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/mfd/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 1c0abd4..608e3e4 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -506,7 +506,7 @@ config PMIC_ADP5520
 
 config MFD_LP8788
 	bool "Texas Instruments LP8788 Power Management Unit Driver"
-	depends on I2C=y
+	depends on I2C=y && GENERIC_HARDIRQS
 	select MFD_CORE
 	select REGMAP_I2C
 	select IRQ_DOMAIN
-- 
1.7.9.5


Best Regards,
Milo


