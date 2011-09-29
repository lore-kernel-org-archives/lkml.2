Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab1I2X04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 19:26:56 -0400
Received: from claw.goop.org ([74.207.240.146]:43200 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932191Ab1I2X0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 19:26:53 -0400
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
Subject: [PATCH RFC 6/8] powerpc/jump_label: add arch_jump_label_transform_early()
Date: Thu, 29 Sep 2011 16:26:36 -0700
Message-Id: <2094e79203a950e210b579284330a1b8b774cbdd.1317338254.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6.2
In-Reply-To: <cover.1317338254.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317338254.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1317338254.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317338254.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

This allows jump-label entries to be modified early, in a pre-SMP
environment.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Michael Ellerman <michael@ellerman.id.au>
---
 arch/powerpc/kernel/jump_label.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/jump_label.c b/arch/powerpc/kernel/jump_label.c
index 368d158..20c82fb 100644
--- a/arch/powerpc/kernel/jump_label.c
+++ b/arch/powerpc/kernel/jump_label.c
@@ -21,3 +21,9 @@ void arch_jump_label_transform(struct jump_entry *entry,
 	else
 		patch_instruction(addr, PPC_INST_NOP);
 }
+
+void __init arch_jump_label_transform_early(struct jump_entry *entry,
+					    enum jump_label_type type)
+{
+	arch_jump_label_transform(entry, type);
+}
-- 
1.7.6.2

