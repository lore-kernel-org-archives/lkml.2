Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab0FHGfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 02:35:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:5496 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169Ab0FHGfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 02:35:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,383,1272870000"; 
   d="scan'208";a="628432148"
Subject: [PATCH 1/2] Add HW_ERR printk prefix for hardware error logging
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Jun 2010 14:35:38 +0800
Message-ID: <1275978938.3444.667.camel@yhuang-dev.sh.intel.com>
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
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 8317ec4..3bf740b 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -247,6 +247,13 @@ extern struct pid *session_of_pgrp(struct pid *pgrp);
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


