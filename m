Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab2GUVmD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 17:42:03 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:38824 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab2GUVmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 17:42:00 -0400
Date: Sat, 21 Jul 2012 14:41:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] acpi: fix pwr_btn_event_pending build error
Message-ID: <20120721214156.GA2515@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072121-6148-0000-0000-000007DEEE93
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

A recent build for KVM on x86 resulted in the following build error:

drivers/acpi/sleep.c:60:13: warning: ‘pwr_btn_event_pending’ defined but not
+used [-Wunused-variable]

This patch silences this error.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 8856102..18347aa 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -57,7 +57,9 @@ MODULE_PARM_DESC(gts, "Enable evaluation of _GTS on suspend.");
 MODULE_PARM_DESC(bfs, "Enable evaluation of _BFS on resume".);
 
 static u8 sleep_states[ACPI_S_STATE_COUNT];
+#ifdef CONFIG_ACPI_SLEEP
 static bool pwr_btn_event_pending;
+#endif /* #ifdef CONFIG_ACPI_SLEEP */
 
 static void acpi_sleep_tts_switch(u32 acpi_state)
 {

