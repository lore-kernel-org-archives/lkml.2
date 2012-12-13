Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab2LMRG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 12:06:28 -0500
Received: from zmc.proxad.net ([212.27.53.206]:36782 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872Ab2LMRG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 12:06:27 -0500
From: Florian Fainelli <florian@openwrt.org>
To: linux-kernel@vger.kernel.org (open list)
Cc: Florian Fainelli <florian@openwrt.org>
Subject: [PATCH] x86: fix perf build with uclibc toolchains
Date: Thu, 13 Dec 2012 18:04:17 +0100
Message-Id: <1355418259-27566-1-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20121211090910.GA22985@gmail.com>
References: <20121211090910.GA22985@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

libio.h is not provided by uClibc, in order to be able to test the
definition of __UCLIBC__ we need to include stdlib.h, which also
includes stddef.h, providing the definition of 'NULL'

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 tools/perf/arch/x86/util/dwarf-regs.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/arch/x86/util/dwarf-regs.c b/tools/perf/arch/x86/util/dwarf-regs.c
index a794d30..6f5267f 100644
--- a/tools/perf/arch/x86/util/dwarf-regs.c
+++ b/tools/perf/arch/x86/util/dwarf-regs.c
@@ -20,7 +20,10 @@
  *
  */
 
+#include <stdlib.h>
+#ifndef __UCLIBC__
 #include <libio.h>
+#endif
 #include <dwarf-regs.h>
 
 /*
-- 
1.7.10.4

