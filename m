Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab0FKGEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 02:04:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:46591 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886Ab0FKGEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 02:04:40 -0400
Date: Fri, 11 Jun 2010 06:04:22 GMT
From: tip-bot for Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, hpa@zytor.com,
       mingo@redhat.com, seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, ying.huang@intel.com,
       linux-kernel@vger.kernel.org, seto.hidetoshi@jp.fujitsu.com,
       tglx@linutronix.de
In-Reply-To: <1275295689.3444.462.camel@yhuang-dev.sh.intel.com>
References: <1275295689.3444.462.camel@yhuang-dev.sh.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mce] x86, mce: Add HW_ERR printk prefix for hardware error logging
Message-ID: <tip-c6de9f08912311ddc1b3502b90e10fd449acd401@git.kernel.org>
Git-Commit-ID: c6de9f08912311ddc1b3502b90e10fd449acd401
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 11 Jun 2010 06:04:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c6de9f08912311ddc1b3502b90e10fd449acd401
Gitweb:     http://git.kernel.org/tip/c6de9f08912311ddc1b3502b90e10fd449acd401
Author:     Huang Ying <ying.huang@intel.com>
AuthorDate: Mon, 31 May 2010 16:48:09 +0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 10 Jun 2010 21:28:43 -0700

x86, mce: Add HW_ERR printk prefix for hardware error logging

This makes hardware error related log in printk log more explicit. So
that the users can report it to hardware vendor instead of LKML or
software vendor.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
LKML-Reference: <1275295689.3444.462.camel@yhuang-dev.sh.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
