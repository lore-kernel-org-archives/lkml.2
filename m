Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab1BXSHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 13:07:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:6491 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755064Ab1BXSHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 13:07:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,219,1297065600"; 
   d="scan'208";a="606213962"
From: james_p_freyensee@linux.intel.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        james_p_freyensee@linux.intel.com, christophe.guerard@intel.com
Subject: [PATCH 10/10] n_tracerouter and n_tracesink compile configurations.
Date: Thu, 24 Feb 2011 10:07:04 -0800
Message-Id: <1298570824-26085-11-git-send-email-james_p_freyensee@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Freyensee <james_p_freyensee@linux.intel.com>

This patch allows n_tracerouter and n_tracesink to be compiled and
configured in the Linux kernel.

Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
---
 drivers/char/Kconfig |   32 ++++++++++++++++++++++++++++++++
 drivers/tty/Makefile |    2 ++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 43d3395..02b9be2 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -289,6 +289,38 @@ config N_GSM
 	  This line discipline provides support for the GSM MUX protocol and
 	  presents the mux as a set of 61 individual tty devices.
 
+config TRACE_ROUTER
+        tristate "Trace data router for MIPI P1149.7 cJTAG standard"
+                depends on TRACE_SINK
+                default Y
+        ---help---
+          The trace router uses the Linux tty line discipline framework to
+          route trace data coming from a tty port (say UART for example) to
+           the trace sink line discipline driver and to another tty port(say USB).
+           This is part of a solution for the MIPI P1149.7, compact JTAG,
+           standard, which is for debugging mobile devices. The PTI driver in
+           drivers/misc/pti.c defines the majority of this MIPI solution.
+
+          You should select this driver if the target kernel is meant for
+          a mobile device containing a modem.  Then you will need to select
+          "Trace data sink for MIPI P1149.7 cJTAG standard" line discipline
+          driver.
+
+config TRACE_SINK
+        tristate "Trace data sink for MIPI P1149.7 cJTAG standard"
+                default Y
+        ---help---
+          The trace sink uses the Linux line discipline framework to receive
+          trace data coming from the trace router line discipline driver
+          to a user-defined tty port target, like USB.
+          This is to provide a way to extract modem trace data on
+          devices that do not have a PTI HW module, or just need modem
+          trace data to come out of a different HW output port.
+          This is part of a solution for the P1149.7, compact JTAG, standard.
+
+          If you select this option, you need to select
+          "Trace data router for MIPI P1149.7 cJTAG standard".
+
 config RISCOM8
 	tristate "SDL RISCom/8 card support"
 	depends on SERIAL_NONSTANDARD
diff --git a/drivers/tty/Makefile b/drivers/tty/Makefile
index c43ef48..8c56ffd 100644
--- a/drivers/tty/Makefile
+++ b/drivers/tty/Makefile
@@ -7,5 +7,7 @@ obj-$(CONFIG_MAGIC_SYSRQ)	+= sysrq.o
 obj-$(CONFIG_N_HDLC)		+= n_hdlc.o
 obj-$(CONFIG_N_GSM)		+= n_gsm.o
 obj-$(CONFIG_R3964)		+= n_r3964.o
+obj-$(CONFIG_TRACE_ROUTER)      += n_tracerouter.o
+obj-$(CONFIG_TRACE_SINK)        += n_tracesink.o
 
 obj-y				+= vt/
-- 
1.7.2.3

