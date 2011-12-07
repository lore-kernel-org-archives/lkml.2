Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab1LGI7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 03:59:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44558 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab1LGI7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 03:59:08 -0500
Date: Wed, 7 Dec 2011 00:58:43 -0800
From: tip-bot for H Hartley Sweeten <hartleys@visionengravers.com>
Message-ID: <tip-79f1ddd06471b094ae30eb17b33beb9f1234ca93@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, hartleys@visionengravers.com, tj@kernel.org,
        tglx@linutronix.de, hsweeten@visionengravers.com, rientjes@google.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, hartleys@visionengravers.com, tj@kernel.org,
        tglx@linutronix.de, hsweeten@visionengravers.com, rientjes@google.com,
        mingo@elte.hu
In-Reply-To: <alpine.DEB.2.00.1112061220310.28251@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1112061220310.28251@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Use the same node_distance for 32 and 64-bit
Git-Commit-ID: 79f1ddd06471b094ae30eb17b33beb9f1234ca93
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 07 Dec 2011 00:58:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  79f1ddd06471b094ae30eb17b33beb9f1234ca93
Gitweb:     http://git.kernel.org/tip/79f1ddd06471b094ae30eb17b33beb9f1234ca93
Author:     H Hartley Sweeten <hartleys@visionengravers.com>
AuthorDate: Tue, 6 Dec 2011 12:22:03 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 7 Dec 2011 09:19:10 +0100

x86: Use the same node_distance for 32 and 64-bit

The node_distance function is not x86 64-bit specific.  Having
the #ifdef around the extern function declaration and the
 #define causes the default node_distance macro to be used in
asm-generic/topology.h. This also causes a sparse warning in
arch/x86/mm/numa.c when CONFIG_X86_64 is not set:

warning: symbol '__node_distance' was not declared. Should it be
static?

Remove the #ifdef to fix both issues.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/alpine.DEB.2.00.1112061220310.28251@chino.kir.corp.google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/topology.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index c006924..800f77c 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -130,10 +130,8 @@ extern void setup_node_to_cpumask_map(void);
 	.balance_interval	= 1,					\
 }
 
-#ifdef CONFIG_X86_64
 extern int __node_distance(int, int);
 #define node_distance(a, b) __node_distance(a, b)
-#endif
 
 #else /* !CONFIG_NUMA */
 
