Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab1GOVXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 17:23:41 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:60377 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab1GOVXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 17:23:39 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmxtMZ80VwmRNV6g8=
X-RZG-CLASS-ID: mo00
Date: Fri, 15 Jul 2011 23:23:33 +0200
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org, tcamuso@redhat.com, wim@iguana.be,
        akpm@linux-foundation.org
Subject: [PATCH] watchdog: fix hpwdt Kconfig regression in 3.0-rc
Message-ID: <20110715212333.GA14958@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21.rev5535 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove Kconfig regression caused by commit
a4616153deae053b29a2b7dd9ec4b2a225accfc5 "watchdog: hpwdt: build hpwdt as
module by default with NMI_DECODING enabled"

With the above change applied, hpwdt will be enabled unconditionally by just
entering the Watchdog subscreen in menuconfig. Since this driver is not
essential to boot any box it should remain disabled until it gets manually
enabled, just like all other drivers.

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 drivers/watchdog/Kconfig |    1 -
 1 file changed, 1 deletion(-)

Index: linux-3.0-rc7/drivers/watchdog/Kconfig
===================================================================
--- linux-3.0-rc7.orig/drivers/watchdog/Kconfig
+++ linux-3.0-rc7/drivers/watchdog/Kconfig
@@ -600,7 +600,6 @@ config IT87_WDT
 config HP_WATCHDOG
 	tristate "HP ProLiant iLO2+ Hardware Watchdog Timer"
 	depends on X86
-	default m
 	help
 	  A software monitoring watchdog and NMI sourcing driver. This driver
 	  will detect lockups and provide a stack trace. This is a driver that
