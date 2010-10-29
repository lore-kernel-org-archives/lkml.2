Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761653Ab0J2TBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 15:01:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58800 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759778Ab0J2TBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 15:01:41 -0400
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=P36U7ldvDQ4A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=enOvQawGAAAA:8 a=meVymXHHAAAA:8 a=Yd9E1ygtpj2Ko_7ommoA:9 a=zZ4th3loH_9P0Pu7kskA:7 a=7wDpMHqi8gBLawJWviNBBeDSUSQA:4 a=CDmZd1m5hNYA:10 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=bkT6KWdcy0IA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101029190135.715856039@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 29 Oct 2010 15:00:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>, David Miller <davem@davemloft.net>,
        David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 4/7] jump label: Make arch_jump_label_text_poke_early() optional
References: <20101029190050.674141729@goodmis.org>
Content-Disposition: inline; filename=0004-jump-label-Make-arch_jump_label_text_poke_early-opti.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Some archs do not need to do anything special for jump labels on
startup (like MIPS).  This patch adds a weak function stub for
arch_jump_label_text_poke_early();

Cc: Jason Baron <jbaron@redhat.com>
Cc: David Miller <davem@davemloft.net>
Cc: David Daney <ddaney@caviumnetworks.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <1286218615-24011-2-git-send-email-ddaney@caviumnetworks.com>
LKML-Reference: <20101015201037.703989993@goodmis.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/jump_label.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 12cce78..3b79bd9 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -270,6 +270,13 @@ out:
 	return conflict;
 }
 
+/*
+ * Not all archs need this.
+ */
+void __weak arch_jump_label_text_poke_early(jump_label_t addr)
+{
+}
+
 static __init int init_jump_label(void)
 {
 	int ret;
-- 
1.7.1


