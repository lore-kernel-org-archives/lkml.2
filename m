Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933366Ab1JDTTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 15:19:19 -0400
Received: from claw.goop.org ([74.207.240.146]:56758 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933172Ab1JDTSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:18:18 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>, Jason Baron <jbaron@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH RFC V3 5/8] sparc/jump_label: drop arch_jump_label_text_poke_early()
Date: Tue,  4 Oct 2011 12:18:06 -0700
Message-Id: <e29cdbf8bef7d1f2ec1a71063679ba717ba9af4a.1317755691.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <cover.1317755691.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317755691.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1317755691.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317755691.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

It is no longer used.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: David Miller <davem@davemloft.net>
---
 arch/sparc/kernel/jump_label.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/sparc/kernel/jump_label.c b/arch/sparc/kernel/jump_label.c
index ea2dafc..971fd43 100644
--- a/arch/sparc/kernel/jump_label.c
+++ b/arch/sparc/kernel/jump_label.c
@@ -36,12 +36,4 @@ void arch_jump_label_transform(struct jump_entry *entry,
 	put_online_cpus();
 }
 
-void arch_jump_label_text_poke_early(jump_label_t addr)
-{
-	u32 *insn_p = (u32 *) (unsigned long) addr;
-
-	*insn_p = 0x01000000;
-	flushi(insn_p);
-}
-
 #endif
-- 
1.7.6.4

