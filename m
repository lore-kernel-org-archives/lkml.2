Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab1JAVz6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 17:55:58 -0400
Received: from claw.goop.org ([74.207.240.146]:49172 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab1JAVzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 17:55:43 -0400
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
Subject: [PATCH RFC V2 5/5] sparc/jump_label: drop arch_jump_label_text_poke_early()
Date: Sat,  1 Oct 2011 14:55:37 -0700
Message-Id: <32110af5310f6044f0a19e9b5e3ed2c1c70277c6.1317506051.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6.2
In-Reply-To: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com>
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
1.7.6.2

