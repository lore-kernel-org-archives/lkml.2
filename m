Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab1CILXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 06:23:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:35132 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758Ab1CILXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 06:23:12 -0500
Date: Wed, 9 Mar 2011 11:22:40 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <4D7603DA02000078000351C1@vpn.id2.novell.com>
References: <4D7603DA02000078000351C1@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Remove dead config option X86_CPU
Message-ID: <tip-c49aa5bd1376939b40759a6da5ba6cf701702721@git.kernel.org>
Git-Commit-ID: c49aa5bd1376939b40759a6da5ba6cf701702721
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Mar 2011 11:22:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c49aa5bd1376939b40759a6da5ba6cf701702721
Gitweb:     http://git.kernel.org/tip/c49aa5bd1376939b40759a6da5ba6cf701702721
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Tue, 8 Mar 2011 09:24:26 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Mar 2011 10:39:36 +0100

x86: Remove dead config option X86_CPU

This isn't being referenced anywhere, and the selects done from
it can be easily done together with all the other X86 ones.

 v2: Also adjust UML's Kconfig.x86.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <4D7603DA02000078000351C1@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/um/Kconfig.x86  |    2 ++
 arch/x86/Kconfig     |    2 ++
 arch/x86/Kconfig.cpu |    5 -----
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/um/Kconfig.x86 b/arch/um/Kconfig.x86
index 62f2115..02fb017 100644
--- a/arch/um/Kconfig.x86
+++ b/arch/um/Kconfig.x86
@@ -10,6 +10,8 @@ endmenu
 
 config UML_X86
 	def_bool y
+	select GENERIC_FIND_FIRST_BIT
+	select GENERIC_FIND_NEXT_BIT
 
 config 64BIT
 	bool
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d5ed94d..43214e3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -64,6 +64,8 @@ config X86
 	select HAVE_TEXT_POKE_SMP
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_SPARSE_IRQ
+	select GENERIC_FIND_FIRST_BIT
+	select GENERIC_FIND_NEXT_BIT
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
 	select USE_GENERIC_SMP_HELPERS if SMP
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 283c5a6..ed47e6e 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -294,11 +294,6 @@ config X86_GENERIC
 
 endif
 
-config X86_CPU
-	def_bool y
-	select GENERIC_FIND_FIRST_BIT
-	select GENERIC_FIND_NEXT_BIT
-
 #
 # Define implied options from the CPU selection here
 config X86_INTERNODE_CACHE_SHIFT
