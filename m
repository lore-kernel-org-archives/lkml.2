Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761465Ab2C3UhP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:37:15 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:59908 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761449Ab2C3UhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:37:12 -0400
Message-ID: <4F761976.1080105@xenotime.net>
Date: Fri, 30 Mar 2012 13:37:10 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 4/8] Documentation: CodingStyle: add inline assembly guidelines
References: <4F761580.3020807@xenotime.net>
In-Reply-To: <4F761580.3020807@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Triplett <josh@joshtriplett.org>

Documentation/CodingStyle: Add guidelines for inline assembly

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 Documentation/CodingStyle |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- lnx-33.orig/Documentation/CodingStyle
+++ lnx-33/Documentation/CodingStyle
@@ -793,6 +793,35 @@ own custom mode, or may have some other
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
 
