Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab1GHFSK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:18:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41761 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503Ab1GHFBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:01:53 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:55 2011
Message-Id: <20110708001655.729061642@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [031/107] xen/mmu: Fix for linker errors when CONFIG_SMP is not defined.
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 32dd11942aeb47f91209a446d6b10063c5b69389 upstream.

Simple enough - we use an extern defined symbol which is not
defined when CONFIG_SMP is not defined. This fixes the linker
dying.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/mmu.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1354,7 +1354,11 @@ static void xen_flush_tlb_others(const s
 {
 	struct {
 		struct mmuext_op op;
+#ifdef CONFIG_SMP
 		DECLARE_BITMAP(mask, num_processors);
+#else
+		DECLARE_BITMAP(mask, NR_CPUS);
+#endif
 	} *args;
 	struct multicall_space mcs;
 


