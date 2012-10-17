Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab2JQFVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 01:21:43 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38305 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab2JQFVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 01:21:31 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, pdsw-power-team@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/2] cpufreq: Debugging options for the cpufreq subsystem
Date: Wed, 17 Oct 2012 10:50:24 +0530
Message-Id: <bf2567a3c3b6f35c606ea8d71722048eefb0c45a.1350451100.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <3b38cb8ab136e5af3a70fceb7d77ad9fc889eb3f.1350451100.git.viresh.kumar@linaro.org>
References: <3b38cb8ab136e5af3a70fceb7d77ad9fc889eb3f.1350451100.git.viresh.kumar@linaro.org>
In-Reply-To: <3b38cb8ab136e5af3a70fceb7d77ad9fc889eb3f.1350451100.git.viresh.kumar@linaro.org>
References: <3b38cb8ab136e5af3a70fceb7d77ad9fc889eb3f.1350451100.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 17 Oct 2012 05:21:28.0641 (UTC) FILETIME=[42B40B10:01CDAC27]
X-MC-Unique: 112101706213001701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q9H5LmaH002068

This adds Kconfig options for DEBUG and VERBOSE_DEBUG to the cpufreq subsystem,
This is pretty useful for developers who want to debug cpufreq subsystem and
don't want to editing the Makefile manually each time they want to debug.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/Kconfig  | 14 ++++++++++++++
 drivers/cpufreq/Makefile |  4 ++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index e24a2a1..b9ee95c 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -17,6 +17,20 @@ config CPU_FREQ
 
 if CPU_FREQ
 
+config CPUFREQ_DEBUG
+        bool "cpufreq debugging"
+        help
+	  This is an option for use by developers; most people should say N
+	  here. This enables cpufreq core and debugging.
+
+config CPUFREQ_VDEBUG
+        bool "cpufreq verbose debugging"
+        depends on CPUFREQ_DEBUG != n
+        help
+	  This is an option for use by developers; most people should say N
+	  here.  This enables deeper (more verbose) debugging of the cpufreq
+	  core and drivers.
+
 config CPU_FREQ_TABLE
 	tristate
 
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index fe4cd26..df4cfc8 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -1,3 +1,7 @@
+# CPUfreq core & drivers debugging
+ccflags-$(CONFIG_CPUFREQ_DEBUG)		:= -DDEBUG
+ccflags-$(CONFIG_CPUFREQ_VDEBUG)	+= -DVERBOSE_DEBUG
+
 # CPUfreq core
 obj-$(CONFIG_CPU_FREQ)			+= cpufreq.o
 # CPUfreq stats
-- 
1.7.12.rc2.18.g61b472e


