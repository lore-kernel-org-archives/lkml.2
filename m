Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab1CHJYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 04:24:36 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:35069 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab1CHJYc convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Tue, 8 Mar 2011 04:24:32 -0500
Message-Id: <4D7603DA02000078000351C1@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 08 Mar 2011 09:24:26 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH, v2] x86: remove dead config option X86_CPU
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This isn't being referenced anywhere, and the selects done from it can
be easily done together with all the other X86 ones.

v2: Also adjust UML's Kconfig.x86.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/um/Kconfig.x86  |    2 ++
 arch/x86/Kconfig     |    2 ++
 arch/x86/Kconfig.cpu |    5 -----
 3 files changed, 4 insertions(+), 5 deletions(-)

--- 2.6.38-rc8/arch/um/Kconfig.x86
+++ 2.6.38-rc8-x86-remove-X86_CPU/arch/um/Kconfig.x86
@@ -10,6 +10,8 @@ endmenu
 
 config UML_X86
 	def_bool y
+	select GENERIC_FIND_FIRST_BIT
+	select GENERIC_FIND_NEXT_BIT
 
 config 64BIT
 	bool
--- 2.6.38-rc8/arch/x86/Kconfig
+++ 2.6.38-rc8-x86-remove-X86_CPU/arch/x86/Kconfig
@@ -64,6 +64,8 @@ config X86
 	select HAVE_TEXT_POKE_SMP
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_SPARSE_IRQ
+	select GENERIC_FIND_FIRST_BIT
+	select GENERIC_FIND_NEXT_BIT
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
 	select USE_GENERIC_SMP_HELPERS if SMP
--- 2.6.38-rc8/arch/x86/Kconfig.cpu
+++ 2.6.38-rc8-x86-remove-X86_CPU/arch/x86/Kconfig.cpu
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



