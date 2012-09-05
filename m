Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759770Ab2IEWkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 18:40:19 -0400
Received: from mail-yw0-f52.google.com ([209.85.213.52]:40772 "EHLO
	mail-yw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759731Ab2IEWkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 18:40:17 -0400
Date: Wed, 5 Sep 2012 15:40:12 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] perf: remove unneeded include of network header files
Message-ID: <20120905224012.GG8203@ghostprotocols.net>
References: <1346881986-59136-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346881986-59136-1-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Sep 05, 2012 at 03:53:06PM -0600, David Ahern escreveu:
> perf does not have networking related functionality, and the inclusion of
> these headers is one of the causes of compile failures for Android:
>   https://lkml.org/lkml/2012/8/23/316
>   https://lkml.org/lkml/2012/8/28/293
> 
> So, remove them.
> 
> v2:
> - netdb.h is required by trace-event-perl.c, so leave it in

Nope, I've applied this instead:

commit 12046099160e65cddb639f8b3dda2bd0701c09d6
Author: David Ahern <dsahern@gmail.com>
Date:   Wed Aug 29 09:55:32 2012 -0600

    perf tools: remove unneeded include of network header files
    
    perf does not have networking related functionality, and the inclusion
    of these headers is one of the causes of compile failures for Android:
    
      https://lkml.org/lkml/2012/8/23/316
      https://lkml.org/lkml/2012/8/28/293
    
    So, remove them.
    
    Signed-off-by: David Ahern <dsahern@gmail.com>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Ingo Molnar <mingo@kernel.org>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Link: http://lkml.kernel.org/r/1346255732-93246-1-git-send-email-dsahern@gmail.com
    [ committer note: fix trace-event-perl.c compile failure by reordering includes ]
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index d280010..94e6736 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -25,16 +25,16 @@
 #include <ctype.h>
 #include <errno.h>
 
-#include "../../perf.h"
 #include "../util.h"
+#include <EXTERN.h>
+#include <perl.h>
+
+#include "../../perf.h"
 #include "../thread.h"
 #include "../event.h"
 #include "../trace-event.h"
 #include "../evsel.h"
 
-#include <EXTERN.h>
-#include <perl.h>
-
 void boot_Perf__Trace__Context(pTHX_ CV *cv);
 void boot_DynaLoader(pTHX_ CV *cv);
 typedef PerlInterpreter * INTERP;
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 00a93a9..67a3713 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -69,11 +69,6 @@
 #include <sys/poll.h>
 #include <sys/socket.h>
 #include <sys/ioctl.h>
-#include <sys/select.h>
-#include <netinet/in.h>
-#include <netinet/tcp.h>
-#include <arpa/inet.h>
-#include <netdb.h>
 #include <inttypes.h>
 #include "../../../include/linux/magic.h"
 #include "types.h"
