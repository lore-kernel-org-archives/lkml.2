Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab0GHHQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 03:16:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:51498 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252Ab0GHHQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 03:16:40 -0400
Date: Thu, 8 Jul 2010 07:16:19 GMT
From: tip-bot for Feng Tang <feng.tang@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       dtor@mail.ru, tglx@linutronix.de, hpa@linux.intel.com,
       feng.tang@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       dtor@mail.ru, tglx@linutronix.de, feng.tang@intel.com,
       hpa@linux.intel.com
In-Reply-To: <1278342202-10973-3-git-send-email-feng.tang@intel.com>
References: <1278342202-10973-3-git-send-email-feng.tang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mrst: Add i8042_detect API for Moorestwon platform
Message-ID: <tip-6d2cce62017efe957e34cfcbba23861b7671980b@git.kernel.org>
Git-Commit-ID: 6d2cce62017efe957e34cfcbba23861b7671980b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 08 Jul 2010 07:16:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6d2cce62017efe957e34cfcbba23861b7671980b
Gitweb:     http://git.kernel.org/tip/6d2cce62017efe957e34cfcbba23861b7671980b
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Mon, 5 Jul 2010 23:03:19 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 7 Jul 2010 17:05:06 -0700

x86, mrst: Add i8042_detect API for Moorestwon platform

It will just return 0 as there is no i8042 controller

Signed-off-by: Feng Tang <feng.tang@intel.com>
LKML-Reference: <1278342202-10973-3-git-send-email-feng.tang@intel.com>
Acked-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/mrst.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
index e796448..5915e0b 100644
--- a/arch/x86/kernel/mrst.c
+++ b/arch/x86/kernel/mrst.c
@@ -216,6 +216,12 @@ static void __init mrst_setup_boot_clock(void)
 		setup_boot_APIC_clock();
 };
 
+/* MID systems don't have i8042 controller */
+static int mrst_i8042_detect(void)
+{
+	return 0;
+}
+
 /*
  * Moorestown specific x86_init function overrides and early setup
  * calls.
@@ -233,6 +239,7 @@ void __init x86_mrst_early_setup(void)
 	x86_cpuinit.setup_percpu_clockev = mrst_setup_secondary_clock;
 
 	x86_platform.calibrate_tsc = mrst_calibrate_tsc;
+	x86_platform.i8042_detect = mrst_i8042_detect;
 	x86_init.pci.init = pci_mrst_init;
 	x86_init.pci.fixup_irqs = x86_init_noop;
 
