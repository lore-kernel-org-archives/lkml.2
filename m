Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab0HRGFE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 02:05:04 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57369 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab0HRGE7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 02:04:59 -0400
From: "Gopinath, Thara" <thara@ti.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "apw@canonical.com" <apw@canonical.com>
Date: Wed, 18 Aug 2010 11:34:51 +0530
Subject: Checkpatch false positive in 2.6.36-rc1.
Thread-Topic: Checkpatch false positive in 2.6.36-rc1.
Thread-Index: Acs+m0Wl6M9MdN1WS9SDD3tlbxDG3A==
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB0324222271@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andy,

The following is my patch.

Index: linux-omap-pm/arch/arm/plat-omap/Kconfig
===================================================================
--- linux-omap-pm.orig/arch/arm/plat-omap/Kconfig
+++ linux-omap-pm/arch/arm/plat-omap/Kconfig
@@ -37,7 +37,7 @@ config OMAP_DEBUG_LEDS

 config OMAP_SMARTREFLEX
        bool "SmartReflex support"
-       depends on ARCH_OMAP3 && PM
+       depends on (ARCH_OMAP3 || ARCH_OMAP4) && PM
        help
          Say Y if you want to enable SmartReflex.


And the following is the check patch error I am getting

WARNING: please write a paragraph that describes the config symbol fully
#108: FILE: arch/arm/plat-omap/Kconfig:41:
        help

total: 0 errors, 1 warnings, 67 lines checked


I think this is a wrong warning as in the first place this is not a line
introduced or removed by my change. Also If I go to the relevant Kconfig
and take a look at this option it appears as below. So this means there
is an actual paragraph following the help.

config OMAP_SMARTREFLEX
        bool "SmartReflex support"
        depends on (ARCH_OMAP3 || ARCH_OMAP4) && PM
        help
          Say Y if you want to enable SmartReflex.

          SmartReflex can perform continuous dynamic voltage
          scaling around the nominal operating point voltage
          according to silicon characteristics and operating
          conditions. Enabling SmartReflex reduces power
          consumption.

          Please note, that by default SmartReflex is only
          initialized. To enable the automatic voltage
          compensation for VDD1 and VDD2, user must write 1 to
          /debug/pm_debug/Smartreflex/SR<X>/autocomp,
          where X is 1 or 2 for OMAP3


Regards
Thara
