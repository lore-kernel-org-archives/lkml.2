Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762753Ab2ERKuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:50:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42816 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab2ERKuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:50:14 -0400
Date: Fri, 18 May 2012 03:49:44 -0700
From: tip-bot for Seiji Aguchi <seiji.aguchi@hds.com>
Message-ID: <tip-f80f749132165fb083865e51afd65cf0f05dcd62@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, satoru.moriya@hds.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, seiji.aguchi@hds.com,
        tony.luck@intel.com, dle-develop@lists.sourceforge.net,
        tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, satoru.moriya@hds.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        seiji.aguchi@hds.com, tony.luck@intel.com,
        dle-develop@lists.sourceforge.net, tglx@linutronix.de,
        dzickus@redhat.com
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2E4D7A5CE2@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2E4D7A5CE2@USINDEVS01.corp.hds.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/debug] kdump: Execute kmsg_dump(KMSG_DUMP_PANIC)
  after smp_send_stop()
Git-Commit-ID: f80f749132165fb083865e51afd65cf0f05dcd62
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:49:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f80f749132165fb083865e51afd65cf0f05dcd62
Gitweb:     http://git.kernel.org/tip/f80f749132165fb083865e51afd65cf0f05dcd62
Author:     Seiji Aguchi <seiji.aguchi@hds.com>
AuthorDate: Tue, 15 May 2012 17:35:09 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 10:07:37 +0200

kdump: Execute kmsg_dump(KMSG_DUMP_PANIC) after smp_send_stop()

This patch moves kmsg_dump(KMSG_DUMP_PANIC) below smp_send_stop(),
to serialize the crash-logging process via smp_send_stop() and to
thus retrieve a more stable crash image of all CPUs stopped.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Cc: dle-develop@lists.sourceforge.net <dle-develop@lists.sourceforge.net>
Cc: Satoru Moriya <satoru.moriya@hds.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: a.p.zijlstra@chello.nl <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/5C4C569E8A4B9B42A84A977CF070A35B2E4D7A5CE2@USINDEVS01.corp.hds.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/panic.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index b6215b7..d4f0b61 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -108,8 +108,6 @@ void panic(const char *fmt, ...)
 	 */
 	crash_kexec(NULL);
 
-	kmsg_dump(KMSG_DUMP_PANIC);
-
 	/*
 	 * Note smp_send_stop is the usual smp shutdown function, which
 	 * unfortunately means it may not be hardened to work in a panic
