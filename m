Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933604Ab2BBWdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 17:33:15 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:41890 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932599Ab2BBWdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 17:33:13 -0500
X-Originating-IP: 217.70.178.147
X-Originating-IP: 50.43.15.19
Date: Thu, 2 Feb 2012 14:33:05 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Subject: [PATCH] Documentation/CodingStyle: Add guidelines for inline assembly
Message-ID: <20120202223304.GA13069@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 Documentation/CodingStyle |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index 2b90d32..c58b236 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -793,6 +793,35 @@ own custom mode, or may have some other magic method for making indentation
 work correctly.
 
 
+		Chapter 19:  Inline assembly
+
+In architecture-specific code, you may need to use inline assembly to interface
+with CPU or platform functionality.  Don't hesitate to do so when necessary.
+However, don't use inline assembly gratuitously when C can do the job.  You can
+and should poke hardware from C when possible.
+
+Consider writing simple helper functions that wrap common bits of inline
+assembly, rather than repeatedly writing them with slight variations.  Remember
+that inline assembly can use C parameters.
+
+Large, non-trivial assembly functions should go in .S files, with corresponding
+C prototypes defined in C header files.  The C prototypes for assembly
+functions should use "asmlinkage".
+
+You may need to mark your asm statement as volatile, to prevent GCC from
+removing it if GCC doesn't notice any side effects.  You don't always need to
+do so, though, and doing so unnecessarily can limit optimization.
+
+When writing a single inline assembly statement containing multiple
+instructions, put each instruction on a separate line in a separate quoted
+string, and end each string except the last with \n\t to properly indent the
+next instruction in the assembly output:
+
+	asm ("magic %reg1, #42\n\t"
+	     "more_magic %reg2, %reg3"
+	     : /* outputs */ : /* inputs */ : /* clobbers */);
+
+
 
 		Appendix I: References
 
-- 
1.7.9

