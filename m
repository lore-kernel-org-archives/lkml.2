Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab2FTOtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 10:49:15 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51790 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab2FTOtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 10:49:09 -0400
Date: Wed, 20 Jun 2012 16:49:02 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@gmail.com>
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
        Stephane Eranian <eranian@google.com>, Sunjin Yang <fan4326@gmail.com>,
        Tom Zanussi <tzanussi@gmail.com>, Ulrich Drepper <drepper@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/20] perf/core improvements
Message-ID: <20120620144902.GB2007@gmail.com>
References: <1340128221-17348-1-git-send-email-acme@infradead.org>
 <20120620120141.GB1925@gmail.com>
 <1340201223.1520.5.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1340201223.1520.5.camel@leonhard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@gmail.com> wrote:

> 2012-06-20 (수), 14:01 +0200, Ingo Molnar:
> > One Makefile bug I noticed is that lib/tracevents does not clean 
> > out these files:
> > 
> >  .event-parse.d
> >  .parse-filter.d
> >  .parse-utils.d
> >  .trace-seq.d
> > 
> > and this can break the build when the libgcc package upgraded:
> > 
> >  comet:~/tip/tools/perf> make -j
> >      SUBDIR ../lib/traceevent/
> >  make[1]: *** No rule to make target `/usr/lib/gcc/x86_64-redhat-linux/4.7.0/include/stddef.h', 
> >   needed by `event-parse.o'.  Stop.
> >  make: *** [../lib/traceevent//libtraceevent.a] Error 2
> 
> So how should we deal with it? Just plain 'make clean' should 
> delete *.d files or add something like 'make distclean' to do 
> that?

Well, 'make' should notice that they are stale or should 
regenerate them all the time.

Thanks,

	Ingo
