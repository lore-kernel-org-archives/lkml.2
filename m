Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab1DUOR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 10:17:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45048 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab1DUOR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 10:17:27 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=x24wO6K7lf8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=N9PvyhYQ8coRnRUqFUkA:9 a=PUjeQqilurYA:10 a=lSinr4eg3GwA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH][GIT PULL][v2.6.39] ftrace: Build without frame pointers on
 Microblaze
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Michal Simek <monstr@monstr.eu>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 21 Apr 2011 10:17:23 -0400
Message-ID: <1303395443.7181.121.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent


Michal Simek (1):
      ftrace: Build without frame pointers on Microblaze

----
 kernel/trace/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
---------------------------
commit d20ac252821ab9780ddf00b95629547d3cebc857
Author: Michal Simek <monstr@monstr.eu>
Date:   Mon Apr 4 11:20:12 2011 +0200

    ftrace: Build without frame pointers on Microblaze
    
    Microblaze doesn't need/support FRAME_POINTERS in order to have a working
    function tracer.
    
    The patch remove Kconfig warning.
    
    Warning log:
    warning: (LOCKDEP && FAULT_INJECTION_STACKTRACE_FILTER && LATENCYTOP &&
    FUNCTION_TRACER && KMEMCHECK) selects FRAME_POINTER which has unmet direct
    dependencies (DEBUG_KERNEL && (CRIS || M68K || FRV || UML || AVR32 ||
    SUPERH || BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS)
    
    Signed-off-by: Michal Simek <monstr@monstr.eu>
    Link: http://lkml.kernel.org/r/1301908812-8119-2-git-send-email-monstr@monstr.eu
    CC: Frederic Weisbecker <fweisbec@gmail.com>
    CC: Ingo Molnar <mingo@redhat.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 61d7d59f..2ad39e5 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -141,7 +141,7 @@ if FTRACE
 config FUNCTION_TRACER
 	bool "Kernel Function Tracer"
 	depends on HAVE_FUNCTION_TRACER
-	select FRAME_POINTER if !ARM_UNWIND && !S390
+	select FRAME_POINTER if !ARM_UNWIND && !S390 && !MICROBLAZE
 	select KALLSYMS
 	select GENERIC_TRACER
 	select CONTEXT_SWITCH_TRACER


