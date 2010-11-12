Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946Ab0KLVyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:54:09 -0500
Received: from smtp-out.google.com ([74.125.121.35]:27551 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab0KLVyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:54:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=DxjKrGpc0D1xeOyGKV96MlOl+CO9oz/W/uOdZ0dCoDq0YsgD/sfmDMD24TpiQTzEmZ
         KmqPsYyTYwtQWLGD18lg==
Date: Fri, 12 Nov 2010 13:53:57 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 1/5] x86: reduce minimum fake node size to 32M
Message-ID: <alpine.DEB.2.00.1011121352050.13699@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the minimum fake node size from 64MB to 32MB so it is
possible to test NUMA code at a greater scale on smaller machines
(64 nodes on a 2G machine, 1024 nodes on 32G machine with
CONFIG_NODES_SHIFT=10).

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/include/asm/numa_64.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -38,7 +38,7 @@ extern void __cpuinit numa_add_cpu(int cpu);
 extern void __cpuinit numa_remove_cpu(int cpu);
 
 #ifdef CONFIG_NUMA_EMU
-#define FAKE_NODE_MIN_SIZE	((u64)64 << 20)
+#define FAKE_NODE_MIN_SIZE	((u64)32 << 20)
 #define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1UL))
 #endif /* CONFIG_NUMA_EMU */
 #else
