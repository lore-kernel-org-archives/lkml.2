Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab0GHHQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 03:16:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:51470 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581Ab0GHHQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 03:16:05 -0400
Date: Thu, 8 Jul 2010 07:15:41 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       dtor@mail.ru, tglx@linutronix.de, feng.tang@intel.com,
       hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       dtor@mail.ru, tglx@linutronix.de, hpa@linux.intel.com,
       feng.tang@intel.com
In-Reply-To: <1278342202-10973-1-git-send-email-feng.tang@intel.com>
References: <1278342202-10973-1-git-send-email-feng.tang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, platform: Export x86_platform to modules
Message-ID: <tip-72550b3ae545c75897c769d43d62d4be3f3d48fe@git.kernel.org>
Git-Commit-ID: 72550b3ae545c75897c769d43d62d4be3f3d48fe
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 08 Jul 2010 07:15:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  72550b3ae545c75897c769d43d62d4be3f3d48fe
Gitweb:     http://git.kernel.org/tip/72550b3ae545c75897c769d43d62d4be3f3d48fe
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 7 Jul 2010 16:57:46 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 7 Jul 2010 17:05:05 -0700

x86, platform: Export x86_platform to modules

Export x86_platform to modules in preparation of using it for i8042
discovery control.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
LKML-Reference: <1278342202-10973-1-git-send-email-feng.tang@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 arch/x86/kernel/x86_init.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 61a1e8c..ebfb8e4 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -5,6 +5,7 @@
  */
 #include <linux/init.h>
 #include <linux/ioport.h>
+#include <linux/module.h>
 
 #include <asm/bios_ebda.h>
 #include <asm/paravirt.h>
@@ -94,3 +95,5 @@ struct x86_platform_ops x86_platform = {
 	.is_untracked_pat_range		= is_ISA_range,
 	.nmi_init			= default_nmi_init
 };
+
+EXPORT_SYMBOL_GPL(x86_platform);
