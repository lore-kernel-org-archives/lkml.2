Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797Ab2AQRXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 12:23:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57430 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab2AQRXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 12:23:34 -0500
Date: Tue, 17 Jan 2012 09:23:20 -0800
From: tip-bot for Cliff Wickman <cpw@sgi.com>
Message-ID: <tip-88ed9dd7f63c3ae71c1984d99ee2dced0b386dea@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20120116212146.GE5767@sgi.com>
References: <20120116212146.GE5767@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/UV2: Ack BAU interrupt earlier
Git-Commit-ID: 88ed9dd7f63c3ae71c1984d99ee2dced0b386dea
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 17 Jan 2012 09:23:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  88ed9dd7f63c3ae71c1984d99ee2dced0b386dea
Gitweb:     http://git.kernel.org/tip/88ed9dd7f63c3ae71c1984d99ee2dced0b386dea
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Mon, 16 Jan 2012 15:21:46 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 17 Jan 2012 09:09:57 +0100

x86/UV2: Ack BAU interrupt earlier

This patch moves the ack of the BAU interrupt to the beginning
of  the interrupt handler so that there is less possibility of a
lost interrupt and slower response to a shootdown message.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Link: http://lkml.kernel.org/r/20120116212146.GE5767@sgi.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/platform/uv/tlb_uv.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index affea50..4686bf1 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1218,6 +1218,7 @@ void uv_bau_message_interrupt(struct pt_regs *regs)
 	struct ptc_stats *stat;
 	struct msg_desc msgdesc;
 
+	ack_APIC_irq();
 	time_start = get_cycles();
 
 	bcp = &per_cpu(bau_control, smp_processor_id());
@@ -1247,8 +1248,6 @@ void uv_bau_message_interrupt(struct pt_regs *regs)
 		stat->d_nomsg++;
 	else if (count > 1)
 		stat->d_multmsg++;
-
-	ack_APIC_irq();
 }
 
 /*
