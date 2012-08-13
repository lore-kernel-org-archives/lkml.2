Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab2HMOXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 10:23:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16153 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab2HMOXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 10:23:05 -0400
X-Authority-Analysis: v=2.0 cv=LIjkseq9 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=nJMv3_NQHZAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=WIa_LenKEI2MxesMrvgA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1344867782.6935.119.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] perf: Let O= makes handle relative paths
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@amd64.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        "borislav.petkov" <borislav.petkov@amd.com>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung.kim@lge.com>
Date: Mon, 13 Aug 2012 10:23:02 -0400
In-Reply-To: <20120813132438.GA18990@aftab.osrc.amd.com>
References: <1344864055.6935.117.camel@gandalf.stny.rr.com>
	 <20120813132438.GA18990@aftab.osrc.amd.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-13 at 15:24 +0200, Borislav Petkov wrote:

> So wouldn't it make sense to call this ABSOLUTE_O or so then?

That's just because you're russian, and are promoting Vodka! ;-)


Done...

----------

When I did a compile of perf using a relative path for the output
directory, the build failed when it tried to compile libtraceevent. This
is because it continues to use the same relative path when the new
working directory is in a different path.

    SUBDIR ../lib/traceevent/
/bin/sh: line 0: cd: ../../../nobackup/perf/: No such file or directory
Makefile:74: *** output directory "../../../nobackup/perf/" does not exist.  Stop.
make: *** [../../../nobackup/perf///libtraceevent.a] Error 2


Make the path used an absolute path when building perf with O=.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index bde8521..e90e1b4 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -1,6 +1,7 @@
 ifeq ("$(origin O)", "command line")
-	OUTPUT := $(O)/
-	COMMAND_O := O=$(O)
+	ABSOLUTE_O := $(shell cd $(O) ; pwd)
+	OUTPUT := $(ABSOLUTE_O)/
+	COMMAND_O := O=$(ABSOLUTE_O)
 endif
 
 ifneq ($(OUTPUT),)


