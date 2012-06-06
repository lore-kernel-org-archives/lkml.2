Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab2FFHKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 03:10:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35998 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab2FFHKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 03:10:41 -0400
Date: Wed, 6 Jun 2012 00:10:30 -0700
From: tip-bot for Chen Gong <gong.chen@linux.intel.com>
Message-ID: <tip-958fb3c51295764599d6abce87e1a01ace897a3e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, gong.chen@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, gong.chen@linux.intel.com
In-Reply-To: <1338863702-9245-1-git-send-email-gong.chen@linux.intel.com>
References: <1338863702-9245-1-git-send-email-gong.chen@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mce: Fix the MCE poll timer logic
Git-Commit-ID: 958fb3c51295764599d6abce87e1a01ace897a3e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 00:10:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  958fb3c51295764599d6abce87e1a01ace897a3e
Gitweb:     http://git.kernel.org/tip/958fb3c51295764599d6abce87e1a01ace897a3e
Author:     Chen Gong <gong.chen@linux.intel.com>
AuthorDate: Tue, 5 Jun 2012 10:35:02 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 08:28:21 +0200

x86/mce: Fix the MCE poll timer logic

In commit 82f7af09 ("x86/mce: Cleanup timer mess), Thomas just
forgot the "/ 2" there while cleaning up.

Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: bp@amd64.org
Cc: tony.luck@intel.com
Link: http://lkml.kernel.org/r/1338863702-9245-1-git-send-email-gong.chen@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 0a687fd..a97f3c4 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1274,7 +1274,7 @@ static void mce_timer_fn(unsigned long data)
 	 */
 	iv = __this_cpu_read(mce_next_interval);
 	if (mce_notify_irq())
-		iv = max(iv, (unsigned long) HZ/100);
+		iv = max(iv / 2, (unsigned long) HZ/100);
 	else
 		iv = min(iv * 2, round_jiffies_relative(check_interval * HZ));
 	__this_cpu_write(mce_next_interval, iv);
