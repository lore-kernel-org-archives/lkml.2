Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab0KISY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 13:24:27 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59815 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752166Ab0KISYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 13:24:24 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Nishanth Menon <nm@ti.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] PM: Hide OPP configuration when SoCs do not provide an implementation
Date: Tue,  9 Nov 2010 18:24:16 +0000
Message-Id: <1289327056-27950-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the OPP API is only useful with an appropraite SoC-specific
implementation there is no point in offering the ability to enable
the API on general systems. Provide an ARCH_HAS OPP Kconfig symbol
which masks out the option unless selected by an implementation.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 Documentation/power/opp.txt |    3 +++
 kernel/power/Kconfig        |    4 ++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Documentation/power/opp.txt b/Documentation/power/opp.txt
index 44d87ad..cd44558 100644
--- a/Documentation/power/opp.txt
+++ b/Documentation/power/opp.txt
@@ -37,6 +37,9 @@ Typical usage of the OPP library is as follows:
 SoC framework	-> modifies on required cases certain OPPs	-> OPP layer
 		-> queries to search/retrieve information	->
 
+Architectures that provide a SoC framework for OPP should select ARCH_HAS_OPP
+to make the OPP layer available.
+
 OPP layer expects each domain to be represented by a unique device pointer. SoC
 framework registers a set of initial OPPs per device with the OPP layer. This
 list is expected to be an optimally small number typically around 5 per device.
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 29bff61..a5aff3e 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -246,9 +246,13 @@ config PM_OPS
 	depends on PM_SLEEP || PM_RUNTIME
 	default y
 
+config ARCH_HAS_OPP
+	bool
+
 config PM_OPP
 	bool "Operating Performance Point (OPP) Layer library"
 	depends on PM
+	depends on ARCH_HAS_OPP
 	---help---
 	  SOCs have a standard set of tuples consisting of frequency and
 	  voltage pairs that the device will support per voltage domain. This
-- 
1.7.1

