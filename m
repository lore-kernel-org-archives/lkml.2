Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab2FVETv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 00:19:51 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:59353 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab2FVETu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 00:19:50 -0400
X-AuditID: 9c930179-b7befae000006417-33-4fe3f264ae69
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Arun Sharma <asharma@fb.com>,
        Benjamin Redelings <benjamin.redelings@nescent.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, David Ahern <dsahern@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Shan Wei <davidshan@tencent.com>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 00/20] perf/core improvements
References: <1340128221-17348-1-git-send-email-acme@infradead.org>
	<20120620120141.GB1925@gmail.com> <1340201223.1520.5.camel@leonhard>
	<20120620144902.GB2007@gmail.com>
Date: Fri, 22 Jun 2012 13:16:11 +0900
In-Reply-To: <20120620144902.GB2007@gmail.com> (Ingo Molnar's message of "Wed,
	20 Jun 2012 16:49:02 +0200")
Message-ID: <87lijgkmlw.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ingo

On Wed, 20 Jun 2012 16:49:02 +0200, Ingo Molnar wrote:
> Well, 'make' should notice that they are stale or should 
> regenerate them all the time.
>

Could you check the patch below does it?


diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 3d69aa9ff51e..42f018e15f36 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -250,8 +250,12 @@ endef
 all_objs := $(sort $(ALL_OBJS))
 all_deps := $(all_objs:%.o=.%.d)
 
+# let .d file also depends on the source and header files
 define check_deps
-               $(CC) -M $(CFLAGS) $< > $@;
+               @set -e; $(RM) $@; \
+               $(CC) -M $(CFLAGS) $< > $@.$$$$; \
+               sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
+               $(RM) $@.$$$$
 endef
 
 $(gui_deps): ks_version.h
