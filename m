Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab1LPGTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 01:19:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46073 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab1LPGTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 01:19:51 -0500
Date: Thu, 15 Dec 2011 22:19:26 -0800
From: "=?UTF-8?B?dGlwLWJvdCBmb3IgVGltbyBUZXLDpHM=?=" <timo.teras@iki.fi>
Message-ID: <tip-cb3f718de8301a969f8169d7d4160e73baff0b86@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, timo.teras@iki.fi
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, timo.teras@iki.fi
In-Reply-To: <1323961888-10223-1-git-send-email-timo.teras@iki.fi>
References: <1323961888-10223-1-git-send-email-timo.teras@iki.fi>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, centaur: Enable cx8 for VIA Eden too
Git-Commit-ID: cb3f718de8301a969f8169d7d4160e73baff0b86
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 15 Dec 2011 22:19:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cb3f718de8301a969f8169d7d4160e73baff0b86
Gitweb:     http://git.kernel.org/tip/cb3f718de8301a969f8169d7d4160e73baff0b86
Author:     Timo Teräs <timo.teras@iki.fi>
AuthorDate: Thu, 15 Dec 2011 17:11:28 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 15 Dec 2011 08:04:42 -0800

x86, centaur: Enable cx8 for VIA Eden too

My box with following cpuinfo needs the cx8 enabling still:

vendor_id	: CentaurHauls
cpu family	: 6
model		: 13
model name	: VIA Eden Processor 1200MHz
stepping	: 0
cpu MHz		: 1199.940
cache size	: 128 KB

This fixes valgrind to work on my box (it requires and checks
cx8 from cpuinfo).

Signed-off-by: Timo Teräs <timo.teras@iki.fi>
Link: http://lkml.kernel.org/r/1323961888-10223-1-git-send-email-timo.teras@iki.fi
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/centaur.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index e58d978..159103c 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -278,7 +278,7 @@ static void __cpuinit init_c3(struct cpuinfo_x86 *c)
 	}
 #ifdef CONFIG_X86_32
 	/* Cyrix III family needs CX8 & PGE explicitly enabled. */
-	if (c->x86_model >= 6 && c->x86_model <= 9) {
+	if (c->x86_model >= 6 && c->x86_model <= 13) {
 		rdmsr(MSR_VIA_FCR, lo, hi);
 		lo |= (1<<1 | 1<<7);
 		wrmsr(MSR_VIA_FCR, lo, hi);
