Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab0J3Klm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 06:41:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:48429 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab0J3Kll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 06:41:41 -0400
Date: Sat, 30 Oct 2010 10:41:24 GMT
From: tip-bot for David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, tglx@linutronix.de, davem@davemloft.net
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, davem@davemloft.net
In-Reply-To: <20101023.110624.226758370.davem@davemloft.net>
References: <20101023.110624.226758370.davem@davemloft.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] jump_label: Fix unaligned traps on sparc.
Message-ID: <tip-f0daed0242d514033b9ecca9187108d3c4e281a5@git.kernel.org>
Git-Commit-ID: f0daed0242d514033b9ecca9187108d3c4e281a5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 30 Oct 2010 10:41:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f0daed0242d514033b9ecca9187108d3c4e281a5
Gitweb:     http://git.kernel.org/tip/f0daed0242d514033b9ecca9187108d3c4e281a5
Author:     David Miller <davem@davemloft.net>
AuthorDate: Sat, 23 Oct 2010 11:06:24 -0700
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 29 Oct 2010 12:57:06 -0400

jump_label: Fix unaligned traps on sparc.

The vmlinux.lds.h knobs to emit the __jump_table section in the main
kernel image takes care to align the section, but this doesn't help
for the __jump_table section that gets emitted into modules.

Fix the resulting lack of section alignment by explicitly specifying
it in the assembler.

Signed-off-by: David S. Miller <davem@davemloft.net>
LKML-Reference: <20101023.110624.226758370.davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/sparc/include/asm/jump_label.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

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
