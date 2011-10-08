Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab1JHSAM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 14:00:12 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:44557 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853Ab1JHSAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 14:00:10 -0400
X-Greylist: delayed 1852 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Oct 2011 14:00:10 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20112.34922.209107.730268@pilspetsen.it.uu.se>
Date: Sat, 8 Oct 2011 19:29:14 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-tegra@vger.kernel.org
Subject: [PATCH] fix drivers/staging/nvec linkage error when keyboard is disabled
Cc: linux-kernel@vger.kernel.org
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building linux-3.1-rc9 for the Tegra ARM SoC with CONFIG_MFD_NVEC=y
and CONFIG_KEYBOARD_NVEC=n results in the following linkage error:

drivers/built-in.o: In function `tegra_nvec_probe':
/tmp/linux-3.1-rc9/drivers/staging/nvec/nvec.c:373: undefined reference to `nvec_kbd_init'
make: *** [.tmp_vmlinux1] Error 1

Fixed by #ifdef:ing the call to nvec_kbd_init(), similar to the
existing #ifdef CONFIG_SERIO_NVEC_PS2 around the nvec_ps2() call.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
---

--- linux-3.1-rc9/drivers/staging/nvec/nvec.c.~1~	2011-10-08 16:28:20.000000000 +0200
+++ linux-3.1-rc9/drivers/staging/nvec/nvec.c	2011-10-08 19:09:18.000000000 +0200
@@ -370,7 +370,9 @@ static int __devinit tegra_nvec_probe(st
 	nvec_write_async(nvec, EC_ENABLE_EVENT_REPORTING,
 				sizeof(EC_ENABLE_EVENT_REPORTING));
 
+#ifdef CONFIG_KEYBOARD_NVEC
 	nvec_kbd_init(nvec);
+#endif
 #ifdef CONFIG_SERIO_NVEC_PS2
 	nvec_ps2(nvec);
 #endif
