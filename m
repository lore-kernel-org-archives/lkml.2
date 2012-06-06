Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab2FFPTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:19:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39916 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756668Ab2FFPTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:19:17 -0400
Date: Wed, 6 Jun 2012 08:18:48 -0700
From: tip-bot for Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Message-ID: <tip-7071f6b2889bb41bea61891d8a3e6e70517ef5e6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, hpa@zytor.com,
        mingo@kernel.org, kirill.shutemov@linux.intel.com,
        mika.westerberg@linux.intel.com, tglx@linutronix.de,
        sebastian@breakpoint.cc, sameo@linux.intel.com, feng.tang@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, kirill.shutemov@linux.intel.com,
        mika.westerberg@linux.intel.com, sameo@linux.intel.com,
        tglx@linutronix.de, sebastian@breakpoint.cc, feng.tang@intel.com
In-Reply-To: <20120531212025.GA8519@breakpoint.cc>
References: <20120531212025.GA8519@breakpoint.cc>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/intel/moorestown:
  Change intel_scu_devices_create() to __devinit
Git-Commit-ID: 7071f6b2889bb41bea61891d8a3e6e70517ef5e6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 08:18:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7071f6b2889bb41bea61891d8a3e6e70517ef5e6
Gitweb:     http://git.kernel.org/tip/7071f6b2889bb41bea61891d8a3e6e70517ef5e6
Author:     Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
AuthorDate: Thu, 31 May 2012 23:20:25 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 11:58:40 +0200

x86/intel/moorestown: Change intel_scu_devices_create() to __devinit

The allmodconfig hits:

 WARNING: vmlinux.o(.text+0x6553d): Section mismatch in
          reference from the function intel_scu_devices_create() to the
          function .devinit.text: spi_register_board_info()
	  [...]

This patch marks intel_scu_devices_create() as devinit because
it only calls a devinit function, spi_register_board_info().

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Feng Tang <feng.tang@intel.com>
Link: http://lkml.kernel.org/r/20120531212025.GA8519@breakpoint.cc
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/platform/mrst/mrst.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index e31bcd8..fd41a92 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -782,7 +782,7 @@ BLOCKING_NOTIFIER_HEAD(intel_scu_notifier);
 EXPORT_SYMBOL_GPL(intel_scu_notifier);
 
 /* Called by IPC driver */
-void intel_scu_devices_create(void)
+void __devinit intel_scu_devices_create(void)
 {
 	int i;
 
