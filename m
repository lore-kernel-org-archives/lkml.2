Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab0JWSGE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 14:06:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44353
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756352Ab0JWSGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 14:06:02 -0400
Date: Sat, 23 Oct 2010 11:06:24 -0700 (PDT)
Message-Id: <20101023.110624.226758370.davem@davemloft.net>
To: rostedt@goodmis.org
CC: jbaron@redhat.com, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org
Subject: [PATCH] jump_label: Fix unaligned traps on sparc.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The vmlinux.lds.h knobs to emit the __jump_table section in the main
kernel image takes care to align the section, but this doesn't help
for the __jump_table section that gets emitted into modules.

Fix the resulting lack of section alignment by explicitly specifying
it in the assembler.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/arch/sparc/include/asm/jump_label.h b/arch/sparc/include/asm/jump_label.h
index 62e66d7..d95cf44 100644
--- a/arch/sparc/include/asm/jump_label.h
+++ b/arch/sparc/include/asm/jump_label.h
@@ -14,6 +14,7 @@
 			 "nop\n\t"				\
 			 "nop\n\t"				\
 			 ".pushsection __jump_table,  \"a\"\n\t"\
+			 ".align 4\n\t"				\
 			 ".word 1b, %l[" #label "], %c0\n\t"	\
 			 ".popsection \n\t"			\
 			 : :  "i" (key) :  : label);\
