Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab0KZS4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 13:56:21 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:58118 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755538Ab0KZS4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 13:56:18 -0500
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Michal Marek <mmarek@suse.cz>, Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roman Zippel <zippel@linux-m68k.org>, Michal Marek <mmarek@suse.cz>
Subject: [PATCH] kbuild: fix interaction of CONFIG_IKCONFIG and KCONFIG_CONFIG
Date: Fri, 26 Nov 2010 13:56:10 -0500
Message-Id: <1290797770-22877-1-git-send-email-bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the use of .config in kernel/Makefile to $(KCONFIG_CONFIG).

Currently, if you try to build a kernel with KCONFIG_CONFIG set (to a value
not equal to .config) and the config file pointed to by KCONFIG_CONFIG sets
CONFIG_IKCONFIG then the build will fail with:

make[1]: *** No rule to make target `.config', needed by `kernel/config_data.gz'.  Stop.

I think this has been present since the introduction of KCONFIG_CONFIG
in 14cdd3c402bf7c66f0bcd76e290f0770a54a4b21.

Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
CC: Roman Zippel <zippel@linux-m68k.org>
CC: Michal Marek <mmarek@suse.cz>

---
based on 698fd6a2c3ca05ec796072defb5c415289a86cdc of
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

 kernel/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index 0b5ff08..33e0a39 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -121,7 +121,7 @@ $(obj)/configs.o: $(obj)/config_data.h
 # config_data.h contains the same information as ikconfig.h but gzipped.
 # Info from config_data can be extracted from /proc/config*
 targets += config_data.gz
-$(obj)/config_data.gz: .config FORCE
+$(obj)/config_data.gz: $(KCONFIG_CONFIG) FORCE
 	$(call if_changed,gzip)
 
 quiet_cmd_ikconfiggz = IKCFG   $@
-- 
1.7.0.4

