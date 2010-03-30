Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab0C3XOC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:14:02 -0400
Received: from kroah.org ([198.145.64.141]:49333 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756688Ab0C3XNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:13:12 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:59:03 2010
Message-Id: <20100330225903.318240703@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:58:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [88/89] x86: Fix placement of FIX_OHCI1394_BASE
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Beulich <JBeulich@novell.com>

commit ff30a0543e9a6cd732582063e7cae951cdb7acf2 upstream.

Ever for 32-bit with sufficiently high NR_CPUS, and starting
with commit 789d03f584484af85dbdc64935270c8e45f36ef7 also for
64-bit, the statically allocated early fixmap page tables were
not covering FIX_OHCI1394_BASE, leading to a boot time crash
when "ohci1394_dma=early" was used. Despite this entry not being
a permanently used one, it needs to be moved into the permanent
range since it has to be close to FIX_DBGP_BASE and
FIX_EARLYCON_MEM_BASE.

Reported-bisected-and-tested-by: Justin P. Mattock <justinmattock@gmail.com>
Fixes-bug: http://bugzilla.kernel.org/show_bug.cgi?id=14487
Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <4B9E15D30200007800034D23@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/fixmap.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -82,6 +82,9 @@ enum fixed_addresses {
 #endif
 	FIX_DBGP_BASE,
 	FIX_EARLYCON_MEM_BASE,
+#ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
+	FIX_OHCI1394_BASE,
+#endif
 #ifdef CONFIG_X86_LOCAL_APIC
 	FIX_APIC_BASE,	/* local (CPU) APIC) -- required for SMP or not */
 #endif
@@ -126,9 +129,6 @@ enum fixed_addresses {
 	FIX_BTMAP_END = __end_of_permanent_fixed_addresses + 256 -
 			(__end_of_permanent_fixed_addresses & 255),
 	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_SLOTS - 1,
-#ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
-	FIX_OHCI1394_BASE,
-#endif
 #ifdef CONFIG_X86_32
 	FIX_WP_TEST,
 #endif


