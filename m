Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037Ab2FOOWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 10:22:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45235 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756999Ab2FOOWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 10:22:36 -0400
Date: Fri, 15 Jun 2012 07:22:19 -0700
From: tip-bot for Ido Yariv <ido@wizery.com>
Message-ID: <tip-d48daf37a3d2e2b28a61e615c0fc538301edb0dd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        shai@scalemp.com, wfg@linux.intel.com, ido@wizery.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        shai@scalemp.com, wfg@linux.intel.com, tglx@linutronix.de,
        ido@wizery.com
In-Reply-To: <1339688588-12674-1-git-send-email-ido@wizery.com>
References: <1339688588-12674-1-git-send-email-ido@wizery.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/vsmp:
  Fix linker error when CONFIG_PROC_FS is not set
Git-Commit-ID: d48daf37a3d2e2b28a61e615c0fc538301edb0dd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 15 Jun 2012 07:22:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d48daf37a3d2e2b28a61e615c0fc538301edb0dd
Gitweb:     http://git.kernel.org/tip/d48daf37a3d2e2b28a61e615c0fc538301edb0dd
Author:     Ido Yariv <ido@wizery.com>
AuthorDate: Thu, 14 Jun 2012 18:43:08 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 15 Jun 2012 13:54:11 +0200

x86/vsmp: Fix linker error when CONFIG_PROC_FS is not set

set_vsmp_pv_ops() references no_irq_affinity which is undeclared
if CONFIG_PROC_FS isn't set. Fix this by adding an #ifdef around
this variable's access.

Reported-by: Fengguang Wu <wfg@linux.intel.com>
Signed-off-by: Ido Yariv <ido@wizery.com>
Acked-by: Shai Fultheim <shai@scalemp.com>
Link: http://lkml.kernel.org/r/1339688588-12674-1-git-send-email-ido@wizery.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/vsmp_64.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index 6b96a73..3f0285a 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -101,7 +101,10 @@ static void __init set_vsmp_pv_ops(void)
 #ifdef CONFIG_SMP
 	if (cap & ctl & BIT(8)) {
 		ctl &= ~BIT(8);
+#ifdef CONFIG_PROC_FS
+		/* Don't let users change irq affinity via procfs */
 		no_irq_affinity = 1;
+#endif
 	}
 #endif
 
