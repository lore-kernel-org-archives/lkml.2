Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab0JMQPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 12:15:39 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:10643 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab0JMQPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 12:15:37 -0400
Subject: [PATCH v3 6/6] x86: allocate space within a region top-down
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Bob Picco <bpicco@redhat.com>, Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-pci@vger.kernel.org,
        "Horst H. von Brand" <vonbrand@inf.utfsm.cl>,
        linux-kernel@vger.kernel.org, Stefan Becker <chemobejk@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Date: Wed, 13 Oct 2010 10:15:36 -0600
Message-ID: <20101013161536.28476.31047.stgit@bob.kio>
In-Reply-To: <20101013161359.28476.6050.stgit@bob.kio>
References: <20101013161359.28476.6050.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Request that allocate_resource() use available space from high addresses
first, rather than the default of using low addresses first.

The most common place this makes a difference is when we move or assign
new PCI device resources.  Low addresses are generally scarce, so it's
better to use high addresses when possible.  This follows Windows practice
for PCI allocation.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=16228#c42
Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 arch/x86/include/asm/io.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 30a3e97..6cc02c4 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -35,6 +35,7 @@
   */
 
 #define ARCH_HAS_IOREMAP_WC
+#define ARCH_HAS_TOP_DOWN_ALLOC
 
 #include <linux/string.h>
 #include <linux/compiler.h>

