Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab2JCTCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 15:02:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57305 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab2JCTCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 15:02:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: footbridge: remove RTC_IRQ definition
Date: Wed, 3 Oct 2012 19:02:15 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Russell King <linux@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210031902.16200.arnd@arndb.de>
X-Provags-ID: V02:K0:CGElv38qc04Mt+cj3dL0BedqC7R9aOHuX41J7uduMjI
 lk1hhSKtIzTLQaYejPe1YEvojOeU2s+dEYyimUAAVolZ6vfIR6
 si2t2wqHlcpO9dS3OGYXYu4FiKvyN7+QrTU0fj+ftMuyMwtUf6
 Djz5kqmADHhPfATvbwrrZ6MqYptGUvIYq5HNZkfRh32dbFWrCL
 4sduTekaa3b0A+UGOIZWuElotPPG6ydO6v6wNATp/e5Q14yJBS
 9Bc3TvS/AST1ub9JAlrfFg9LAGHKAzzK3a9b4zYFa5UmfFk1bD
 YewIsnqm5ntmPOLOIEPajcYk9EDLX7si1oLWAojlSQLXFSjs0W
 8UEo7sYZPmUIu2EujlF0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit bd8abc9a32c "ARM: mc146818rtc: remove unnecessary include of
mach/irqs.h", building footbridge_defconfig results in this warning:

In file included from include/linux/mc146818rtc.h:16:0,
                 from arch/arm/mach-footbridge/isa-rtc.c:21:
arch/arm/include/asm/mc146818rtc.h:10:0: warning: "RTC_IRQ" redefined [enabled by default]
arch/arm/mach-footbridge/include/mach/irqs.h:93:0: note: this is the location of the previous definition

The above commit was intentionally made to catch errors like this,
where code relies on the RTC_IRQ definition. The only driver using
it is the legacy PC-style drivers/char/rtc.c driver.
However, the ARM architecture has been using the RTC_LIB framework
since at least 2006, and that doesn't use it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com
Cc: Russell King <linux@arm.linux.org.uk>

---
I've queued this in late/fixes for the current merge window. Will
send later unless someone objects.

diff --git a/arch/arm/mach-footbridge/include/mach/irqs.h b/arch/arm/mach-footbridge/include/mach/irqs.h
index 400551e..61c714c 100644
--- a/arch/arm/mach-footbridge/include/mach/irqs.h
+++ b/arch/arm/mach-footbridge/include/mach/irqs.h
@@ -89,8 +89,6 @@
 #define IRQ_NETWINDER_VGA	_ISA_IRQ(11)
 #define IRQ_NETWINDER_SOUND	_ISA_IRQ(12)
 
-#undef RTC_IRQ
-#define RTC_IRQ		IRQ_ISA_RTC_ALARM
 #define I8042_KBD_IRQ	IRQ_ISA_KEYBOARD
 #define I8042_AUX_IRQ	(machine_is_netwinder() ? IRQ_NETWINDER_PS2MOUSE : IRQ_ISA_PS2MOUSE)
 #define IRQ_FLOPPYDISK	IRQ_ISA_FLOPPY
