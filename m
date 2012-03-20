Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181Ab2CTWud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 18:50:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33248 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758908Ab2CTWub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 18:50:31 -0400
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=VdKXIKFENfkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=VFjshNgO1W2xqlf29lQA:9 a=2Pp9E64oga76OzIoLsEA:7 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1332283828.23924.17.camel@gandalf.stny.rr.com>
Subject: [PATCH][GIT PULL] tracing: Move the tracing_on/off() declarations
 into CONFIG_TRACING
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 20 Mar 2012 18:50:28 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This fixes the bug you found with the config. I also added a test to my
test suite, that includes that config combination of having RING_BUFFER
enabled but TRACING not, to catch further bugs similar to this one.

-- Steve 

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/core

Head SHA1: 93d68e52295fb8b65ded6db49e32e63b6a203e0b


Steven Rostedt (1):
      tracing: Move the tracing_on/off() declarations into CONFIG_TRACING

----
 include/linux/kernel.h |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)
---------------------------
commit 93d68e52295fb8b65ded6db49e32e63b6a203e0b
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Tue Mar 20 12:28:29 2012 -0400

    tracing: Move the tracing_on/off() declarations into CONFIG_TRACING
    
    The tracing_on/off() declarations were under CONFIG_RING_BUFFER, but
    the functions are now only defined under CONFIG_TRACING as they are
    specific to ftrace and not the ring buffer.
    
    But the declarations were still defined under the ring buffer and
    this caused the build to fail when CONFIG_RING_BUFFER was set but
    CONFIG_TRACING was not.
    
    Reported-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index e834342..51b9548 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -414,16 +414,10 @@ extern int __must_check hex2bin(u8 *dst, const char *src, size_t count);
  * Most likely, you want to use tracing_on/tracing_off.
  */
 #ifdef CONFIG_RING_BUFFER
-void tracing_on(void);
-void tracing_off(void);
 /* trace_off_permanent stops recording with no way to bring it back */
 void tracing_off_permanent(void);
-int tracing_is_on(void);
 #else
-static inline void tracing_on(void) { }
-static inline void tracing_off(void) { }
 static inline void tracing_off_permanent(void) { }
-static inline int tracing_is_on(void) { return 0; }
 #endif
 
 enum ftrace_dump_mode {
@@ -433,6 +427,10 @@ enum ftrace_dump_mode {
 };
 
 #ifdef CONFIG_TRACING
+void tracing_on(void);
+void tracing_off(void);
+int tracing_is_on(void);
+
 extern void tracing_start(void);
 extern void tracing_stop(void);
 extern void ftrace_off_permanent(void);
@@ -517,6 +515,11 @@ static inline void tracing_start(void) { }
 static inline void tracing_stop(void) { }
 static inline void ftrace_off_permanent(void) { }
 static inline void trace_dump_stack(void) { }
+
+static inline void tracing_on(void) { }
+static inline void tracing_off(void) { }
+static inline int tracing_is_on(void) { return 0; }
+
 static inline int
 trace_printk(const char *fmt, ...)
 {


