Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab0J3BK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 21:10:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:35280 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710Ab0J3BK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 21:10:26 -0400
Date: Sat, 30 Oct 2010 01:10:03 GMT
From: tip-bot for Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        masami.hiramatsu.pt@hitachi.com, mathieu.desnoyers@efficios.com,
        jbaron@redhat.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de, jbaron@redhat.com, hpa@linux.intel.com
In-Reply-To: <20101028152026.GB2875@redhat.com>
References: <20101028152026.GB2875@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, alternative: Call stop_machine_text_poke() on all cpus
Message-ID: <tip-404ba5d7bb958d3d788bdaa0debc0bdf60f13ffe@git.kernel.org>
Git-Commit-ID: 404ba5d7bb958d3d788bdaa0debc0bdf60f13ffe
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 30 Oct 2010 01:10:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  404ba5d7bb958d3d788bdaa0debc0bdf60f13ffe
Gitweb:     http://git.kernel.org/tip/404ba5d7bb958d3d788bdaa0debc0bdf60f13ffe
Author:     Jason Baron <jbaron@redhat.com>
AuthorDate: Thu, 28 Oct 2010 11:20:27 -0400
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 29 Oct 2010 16:42:58 -0700

x86, alternative: Call stop_machine_text_poke() on all cpus

Currently, text_poke_smp() passes a NULL as the third argument to
__stop_machine(), which will only run stop_machine_text_poke()
on 1 cpu. Change NULL -> cpu_online_mask, as stop_machine_text_poke()
is intended to be run on all cpus.

I actually didn't notice any problems with stop_machine_text_poke()
only being called on 1 cpu, but found this via code inspection.

Signed-off-by: Jason Baron <jbaron@redhat.com>
LKML-Reference: <20101028152026.GB2875@redhat.com>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

---
 arch/x86/kernel/alternative.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index a36bb90..5ceeca3 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -638,7 +638,7 @@ void *__kprobes text_poke_smp(void *addr, const void *opcode, size_t len)
 	atomic_set(&stop_machine_first, 1);
 	wrote_text = 0;
 	/* Use __stop_machine() because the caller already got online_cpus. */
-	__stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
+	__stop_machine(stop_machine_text_poke, (void *)&tpp, cpu_online_mask);
 	return addr;
 }
 
