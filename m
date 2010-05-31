Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab0EaIsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 04:48:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:42314 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883Ab0EaIsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 04:48:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,332,1272870000"; 
   d="scan'208";a="626205659"
Subject: [PATCH 1/2] Add HW_ERR printk prefix for hardware error logging
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 May 2010 16:48:09 +0800
Message-ID: <1275295689.3444.462.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes hardware error related log in printk log more explicit. So
that the users can report it to hardware vendor instead of LKML or
software vendor.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 include/linux/kernel.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -247,6 +247,13 @@ extern struct pid *session_of_pgrp(struc
 #define FW_WARN		"[Firmware Warn]: "
 #define FW_INFO		"[Firmware Info]: "
 
+/*
+ * HW_ERR
+ * Add this to a message for hardware errors, so that user can report
+ * it to hardware vendor instead of LKML or software vendor.
+ */
+#define HW_ERR		"[Hardware Error]: "
+
 #ifdef CONFIG_PRINTK
 asmlinkage int vprintk(const char *fmt, va_list args)
 	__attribute__ ((format (printf, 1, 0)));


