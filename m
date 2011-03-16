Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab1CPT7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 15:59:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681Ab1CPT7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 15:59:04 -0400
Date: Wed, 16 Mar 2011 15:58:27 -0400
From: Jason Baron <jbaron@redhat.com>
To: rostedt@goodmis.org
Cc: peterz@infradead.org, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        ralf@linux-mips.org, jang@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        linux-kernel@vger.kernel.org
Message-Id: <e119fbd060c9452c56063ea6148ba1070e7434cc.1300299760.git.jbaron@redhat.com>
In-Reply-To: <cover.1300299760.git.jbaron@redhat.com>
References: <cover.1300299760.git.jbaron@redhat.com>
Subject: [PATCH 3/4] jump label: add _ASM_ALIGN for x86 and x86_64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The linker should not be adding holes to word size aligned pointers, but
out of paranoia we are explicitly specifying that alignment. I have not
seen any holes in the jump label section in practice.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 arch/x86/include/asm/jump_label.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index f217cee..a32b18c 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -16,6 +16,7 @@ static __always_inline bool arch_static_branch(struct jump_label_key *key)
 	asm goto("1:"
 		JUMP_LABEL_INITIAL_NOP
 		".pushsection __jump_table,  \"aw\" \n\t"
+		_ASM_ALIGN "\n\t"
 		_ASM_PTR "1b, %l[l_yes], %c0 \n\t"
 		".popsection \n\t"
 		: :  "i" (key) : : l_yes);
-- 
1.7.1

