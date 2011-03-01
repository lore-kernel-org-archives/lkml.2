Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab1CALe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 06:34:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:38009 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756218Ab1CALe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 06:34:27 -0500
Date: Tue, 1 Mar 2011 11:33:58 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com, hpa@zytor.com,
        mingo@redhat.com, jbeulich@novell.com, JBeulich@novell.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, jdike@addtoit.com,
        linux-kernel@vger.kernel.org, jbeulich@novell.com, JBeulich@novell.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4D6CE3400200007800034498@vpn.id2.novell.com>
References: <4D6CE3400200007800034498@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] um, x86-64: Fix UML build after adding CFI annotations to lib/rwsem_64.S
Message-ID: <tip-bfc39061d3dbf812e6a78f9529a548e5f0050c64@git.kernel.org>
Git-Commit-ID: bfc39061d3dbf812e6a78f9529a548e5f0050c64
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 01 Mar 2011 11:33:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bfc39061d3dbf812e6a78f9529a548e5f0050c64
Gitweb:     http://git.kernel.org/tip/bfc39061d3dbf812e6a78f9529a548e5f0050c64
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Tue, 1 Mar 2011 11:14:55 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 1 Mar 2011 12:19:44 +0100

um, x86-64: Fix UML build after adding CFI annotations to lib/rwsem_64.S

arch/um/Kconfig.x86 has X86_32 but not X86_64 - that's resulting in
asm/dwarf2.h producing the 32-bit (pushl_cfi & Co) macros instead of
the 64-bit ones.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Jeff Dike <jdike@addtoit.com>
LKML-Reference: <4D6CE3400200007800034498@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/um/Kconfig.x86 |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/um/Kconfig.x86 b/arch/um/Kconfig.x86
index 5ee3280..62f2115 100644
--- a/arch/um/Kconfig.x86
+++ b/arch/um/Kconfig.x86
@@ -19,6 +19,9 @@ config X86_32
 	def_bool !64BIT
 	select HAVE_AOUT
 
+config X86_64
+	def_bool 64BIT
+
 config RWSEM_XCHGADD_ALGORITHM
 	def_bool X86_XADD
 
