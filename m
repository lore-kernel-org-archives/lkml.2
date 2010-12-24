Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab0LXBhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 20:37:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:41078 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552Ab0LXBhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 20:37:16 -0500
Date: Fri, 24 Dec 2010 01:36:50 GMT
From: tip-bot for David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com, rientjes@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, rientjes@google.com, hpa@linux.intel.com
In-Reply-To: <alpine.DEB.2.00.1012221700590.3701@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1012221700590.3701@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86, numa: Reduce minimum fake node size to 32M
Message-ID: <tip-34dc9e74968ef4b582c3815b0124d88a68dfabef@git.kernel.org>
Git-Commit-ID: 34dc9e74968ef4b582c3815b0124d88a68dfabef
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 24 Dec 2010 01:36:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  34dc9e74968ef4b582c3815b0124d88a68dfabef
Gitweb:     http://git.kernel.org/tip/34dc9e74968ef4b582c3815b0124d88a68dfabef
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Wed, 22 Dec 2010 17:23:40 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 23 Dec 2010 15:27:10 -0800

x86, numa: Reduce minimum fake node size to 32M

This patch changes the minimum fake node size from 64MB to 32MB so it is
possible to test NUMA code at a greater scale on smaller machines
(64 nodes on a 2G machine, 1024 nodes on 32G machine with
CONFIG_NODES_SHIFT=10).

Signed-off-by: David Rientjes <rientjes@google.com>
LKML-Reference: <alpine.DEB.2.00.1012221700590.3701@chino.kir.corp.google.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/numa_64.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index 823e070..5ae8728 100644
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
