Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab0LFPBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 10:01:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:45839 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab0LFPBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 10:01:36 -0500
Date: Mon, 6 Dec 2010 15:01:20 GMT
From: tip-bot for Feng Tang <feng.tang@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, jacob.jun.pan@intel.com, tglx@linutronix.de,
        feng.tang@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, jacob.jun.pan@intel.com,
        tglx@linutronix.de, feng.tang@intel.com
In-Reply-To: <1291348298-21263-2-git-send-email-feng.tang@intel.com>
References: <1291348298-21263-2-git-send-email-feng.tang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86, apbt: Setup affinity for apb timers acting as per-cpu timer
Message-ID: <tip-e4d2ebcab11b308b5b59073578efd33eccd55d46@git.kernel.org>
Git-Commit-ID: e4d2ebcab11b308b5b59073578efd33eccd55d46
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Dec 2010 15:01:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e4d2ebcab11b308b5b59073578efd33eccd55d46
Gitweb:     http://git.kernel.org/tip/e4d2ebcab11b308b5b59073578efd33eccd55d46
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Fri, 3 Dec 2010 11:51:38 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 6 Dec 2010 15:58:26 +0100

x86, apbt: Setup affinity for apb timers acting as per-cpu timer

Commit a5ef2e70 "x86: Sanitize apb timer interrupt handling" forgot
the affinity setup when cleaning up the code, this patch just
adds the forgotten part

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Jacob Pan <jacob.jun.pan@intel.com>
Cc: Alan Cox <alan@linux.intel.com>
LKML-Reference: <1291348298-21263-2-git-send-email-feng.tang@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apb_timer.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index 92543c7..7c9ab59 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -315,6 +315,7 @@ static void apbt_setup_irq(struct apbt_dev *adev)
 
 	if (system_state == SYSTEM_BOOTING) {
 		irq_modify_status(adev->irq, 0, IRQ_MOVE_PCNTXT);
+		irq_set_affinity(adev->irq, cpumask_of(adev->cpu));
 		/* APB timer irqs are set up as mp_irqs, timer is edge type */
 		__set_irq_handler(adev->irq, handle_edge_irq, 0, "edge");
 		if (request_irq(adev->irq, apbt_interrupt_handler,
