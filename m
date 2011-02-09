Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab1BIATZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 19:19:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:40362 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756019Ab1BIARW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 19:17:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,444,1291622400"; 
   d="scan'208";a="705558326"
From: james_p_freyensee@linux.intel.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        james_p_freyensee@linux.intel.com
Subject: [PATCH 11/12] n_tracerouter and n_tracesink Kconfig.
Date: Tue,  8 Feb 2011 16:17:16 -0800
Message-Id: <1297210637-5934-11-git-send-email-james_p_freyensee@linux.intel.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1297210637-5934-10-git-send-email-james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
 <1297210637-5934-2-git-send-email-james_p_freyensee@linux.intel.com>
 <1297210637-5934-3-git-send-email-james_p_freyensee@linux.intel.com>
 <1297210637-5934-4-git-send-email-james_p_freyensee@linux.intel.com>
 <1297210637-5934-5-git-send-email-james_p_freyensee@linux.intel.com>
 <1297210637-5934-6-git-send-email-james_p_freyensee@linux.intel.com>
 <1297210637-5934-7-git-send-email-james_p_freyensee@linux.intel.com>
 <1297210637-5934-8-git-send-email-james_p_freyensee@linux.intel.com>
 <1297210637-5934-9-git-send-email-james_p_freyensee@linux.intel.com>
 <1297210637-5934-10-git-send-email-james_p_freyensee@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Freyensee <james_p_freyensee@linux.intel.com>

This patch allows n_tracerouter and n_tracesink ldisc drivers
to be configured in menuconfig.

Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
---
 drivers/char/Kconfig |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

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
-- 
1.6.6.1

