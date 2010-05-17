Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab0EQICJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 04:02:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:12732 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564Ab0EQICG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 04:02:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,246,1272870000"; 
   d="scan'208";a="518492318"
Subject: [RFC 1/2] Add HW_ERR printk prefix for hardware error logging
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 May 2010 16:02:04 +0800
Message-ID: <1274083324.3564.653.camel@yhuang-dev.sh.intel.com>
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
@@ -245,6 +245,13 @@ extern struct pid *session_of_pgrp(struc
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


