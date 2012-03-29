Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208Ab2C2Oh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 10:37:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40638 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933121Ab2C2OhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 10:37:20 -0400
Date: Thu, 29 Mar 2012 11:37:12 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] perf tools: Including pre-generated flex files
Message-ID: <20120329143712.GH8482@infradead.org>
References: <20120327181547.GA7374@infradead.org>
 <CA+55aFynFze+AJxUtkiAaOTJ58cK8=aiDi-fQqQ3bDV54w-=+A@mail.gmail.com>
 <20120329122208.GC6949@m.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120329122208.GC6949@m.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Mar 29, 2012 at 02:22:08PM +0200, Jiri Olsa escreveu:
> I just tried to generate the parser on RHEL6 and got:
> 
>     CC util/parse-events-bison.o
> util/parse-events-bison.c:222:6: error: "YYENABLE_NLS" is not defined
> util/parse-events-bison.c:664:6: error: "YYLTYPE_IS_TRIVIAL" is not
> defined
> 
> looks like bison bug, that RHEL6 did not picked up fix for yet.
> 
> I agree with not including the parser sources in git, but we'll probably
> get some screaming from ppl having similar issue like above.
> 
> Also I'm not fully sure we could even use generated bison/flex
> files cross architectures.. need to check :)

I got yet another error here:

[acme@sandy linux]$ rm -rf ../build/perf/
[acme@sandy linux]$ mkdir ../build/perf/
[acme@sandy linux]$ make -j8 -C tools/perf/ O=/home/git/build/perf
install
make: Entering directory `/home/git/linux/tools/perf'
    MKDIR /home/git/build/perf/arch/x86/util
<SNIP>
    MKDIR /home/git/build/perf/util/ui/browsers
PERF_VERSION = perf.urgent.for.mingo.6.g7e025ca
make: Leaving directory `/home/git/linux/tools/perf'
make: Entering directory `/home/git/linux/tools/perf'
    GEN /home/git/build/perf/common-cmds.h
    * new build flags or prefix
    CC /home/git/build/perf/bench/mem-memcpy-x86-64-asm.o
<SNIP>
    CC /home/git/build/perf/util/trace-event-parse.o
    BISON event-parser
    CC /home/git/build/perf/util/parse-events-bison.o
    FLEX event-parser
    BISON pmu-parser
util/parse-events-bison.c:150:10: error: missing terminating " character
util/parse-events-bison.c:150:10: error: ""util/par" is not a valid
filename
util/parse-events-bison.c:145:1: error: unterminated #if
util/parse-events-bison.c:147: error: expected specifier-qualifier-list
at end of input
make: *** [/home/git/build/perf/util/parse-events-bison.o] Error 1
make: *** Waiting for unfinished jobs....
    FLEX pmu-parser
make: Leaving directory `/home/git/linux/tools/perf'
[acme@sandy linux]$ 

- Arnaldo
