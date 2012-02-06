Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab2BFXj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 18:39:59 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:57098 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab2BFXj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 18:39:56 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EADRkME9bdWOb/2dsb2JhbABDhQurP4FzAQUjBAsBIyMQJQIYDgICOQMbBgESh3+mR5IngS+JfwEFAgICCAEBBA0EBgELCQgUg0peFYJCgRYElSiFWINXiS0
X-IronPort-AV: E=Sophos;i="4.73,373,1325458800"; 
   d="scan'208";a="473049158"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 4/4] staging: tidspbridge: remove CONFIG_TIDSPBRIDGE_DEBUG
Date: Tue,  7 Feb 2012 00:39:37 +0100
Message-Id: <79eac1538a78cb14e843951e04ffffe6edce8591.1328563909.git.vjaquez@igalia.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <cover.1328563908.git.vjaquez@igalia.com>
References: <cover.1328563908.git.vjaquez@igalia.com>
In-Reply-To: <cover.1328563908.git.vjaquez@igalia.com>
References: <cover.1328563908.git.vjaquez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since all the asserts and DBC macros are gone, the kconfig macro
CONFIG_TIDSPBRIDGE_DEBUG is not almost used, but for printing trace messages.

Since it is almost not used, I don't see any case for keep it churning the
configuration menu.

This patch removes completely the kconfig macro CONFIG_TIDSPBRIDGE_DEBUG,
using only TIDSPBRIDGE_BACKTRACE for enabling the debug trace messages.

Signed-off-by: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
---
 drivers/staging/tidspbridge/Kconfig                |    6 ------
 drivers/staging/tidspbridge/core/io_sm.c           |   12 ++++++------
 .../staging/tidspbridge/include/dspbridge/io_sm.h  |    2 --
 3 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/tidspbridge/Kconfig b/drivers/staging/tidspbridge/Kconfig
index 21a559e..d660891 100644
--- a/drivers/staging/tidspbridge/Kconfig
+++ b/drivers/staging/tidspbridge/Kconfig
@@ -31,12 +31,6 @@ config TIDSPBRIDGE_MEMPOOL_SIZE
 	  Allocate specified size of memory at booting time to avoid allocation
 	  failure under heavy memory fragmentation after some use time.
 
-config TIDSPBRIDGE_DEBUG
-	bool "Debug Support"
-	depends on TIDSPBRIDGE
-	help
-	  Say Y to enable Bridge debugging capabilities
-
 config TIDSPBRIDGE_RECOVERY
 	bool "Recovery Support"
 	depends on TIDSPBRIDGE
diff --git a/drivers/staging/tidspbridge/core/io_sm.c b/drivers/staging/tidspbridge/core/io_sm.c
index d47b861..9b50b5b 100644
--- a/drivers/staging/tidspbridge/core/io_sm.c
+++ b/drivers/staging/tidspbridge/core/io_sm.c
@@ -111,7 +111,7 @@ struct io_mgr {
 	struct mgr_processorextinfo ext_proc_info;
 	struct cmm_object *cmm_mgr;	/* Shared Mem Mngr */
 	struct work_struct io_workq;	/* workqueue */
-#if defined(CONFIG_TIDSPBRIDGE_BACKTRACE) || defined(CONFIG_TIDSPBRIDGE_DEBUG)
+#if defined(CONFIG_TIDSPBRIDGE_BACKTRACE)
 	u32 trace_buffer_begin;	/* Trace message start address */
 	u32 trace_buffer_end;	/* Trace message end address */
 	u32 trace_buffer_current;	/* Trace message current address */
@@ -243,7 +243,7 @@ int bridge_io_destroy(struct io_mgr *hio_mgr)
 		/* Free IO DPC object */
 		tasklet_kill(&hio_mgr->dpc_tasklet);
 
-#if defined(CONFIG_TIDSPBRIDGE_BACKTRACE) || defined(CONFIG_TIDSPBRIDGE_DEBUG)
+#if defined(CONFIG_TIDSPBRIDGE_BACKTRACE)
 		kfree(hio_mgr->msg);
 #endif
 		dsp_wdt_exit();
@@ -383,7 +383,7 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
 		status = -EFAULT;
 	}
 	if (!status) {
-#if defined(CONFIG_TIDSPBRIDGE_BACKTRACE) || defined(CONFIG_TIDSPBRIDGE_DEBUG)
+#if defined(CONFIG_TIDSPBRIDGE_BACKTRACE)
 		status =
 		    cod_get_sym_value(cod_man, DSP_TRACESEC_END, &shm0_end);
 #else
@@ -728,7 +728,7 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
 		hmsg_mgr->max_msgs);
 	memset((void *)hio_mgr->shared_mem, 0, sizeof(struct shm));
 
-#if defined(CONFIG_TIDSPBRIDGE_BACKTRACE) || defined(CONFIG_TIDSPBRIDGE_DEBUG)
+#if defined(CONFIG_TIDSPBRIDGE_BACKTRACE)
 	/* Get the start address of trace buffer */
 	status = cod_get_sym_value(cod_man, SYS_PUTCBEG,
 				   &hio_mgr->trace_buffer_begin);
@@ -907,7 +907,7 @@ void io_dpc(unsigned long ref_data)
 		}
 
 #endif
-#ifdef CONFIG_TIDSPBRIDGE_DEBUG
+#ifdef CONFIG_TIDSPBRIDGE_BACKTRACE
 		if (pio_mgr->intr_val & MBX_DBG_SYSPRINTF) {
 			/* Notify DSP Trace message */
 			print_dsp_debug_trace(pio_mgr);
@@ -1666,7 +1666,7 @@ int bridge_io_get_proc_load(struct io_mgr *hio_mgr,
 }
 
 
-#if defined(CONFIG_TIDSPBRIDGE_BACKTRACE) || defined(CONFIG_TIDSPBRIDGE_DEBUG)
+#if defined(CONFIG_TIDSPBRIDGE_BACKTRACE)
 void print_dsp_debug_trace(struct io_mgr *hio_mgr)
 {
 	u32 ul_new_message_length = 0, ul_gpp_cur_pointer;
diff --git a/drivers/staging/tidspbridge/include/dspbridge/io_sm.h b/drivers/staging/tidspbridge/include/dspbridge/io_sm.h
index a054dad..903ff12 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/io_sm.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/io_sm.h
@@ -154,8 +154,6 @@ int dump_dsp_stack(struct bridge_dev_context *bridge_context);
 
 void dump_dl_modules(struct bridge_dev_context *bridge_context);
 
-#endif
-#if defined(CONFIG_TIDSPBRIDGE_BACKTRACE) || defined(CONFIG_TIDSPBRIDGE_DEBUG)
 void print_dsp_debug_trace(struct io_mgr *hio_mgr);
 #endif
 
-- 
1.7.8.3

