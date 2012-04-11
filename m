Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761006Ab2DKTws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 15:52:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:44696 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab2DKTwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 15:52:46 -0400
Date: Wed, 11 Apr 2012 16:52:44 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@kernel.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH v5 5/5] tools: Connect to the kernel build system
Message-ID: <20120411195244.GL16257@infradead.org>
References: <1334162178-17152-1-git-send-email-bp@amd64.org>
 <1334162178-17152-6-git-send-email-bp@amd64.org>
 <20120411180434.GH16257@infradead.org>
 <20120411180837.GJ16257@infradead.org>
 <4F85CB23.8030305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F85CB23.8030305@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Apr 11, 2012 at 12:19:15PM -0600, David Ahern escreveu:
> On 4/11/12 12:08 PM, Arnaldo Carvalho de Melo wrote:
> 
> >>[acme@sandy linux]$ make -j8 O=/home/git/build/perf tools/perf_install
> >>[acme@sandy linux]$ ls -la tools/perf/*.o | wc -l
> >>22
> >>
> >>It should have honoured O=
> >>
> >>Can you fix this one please? :)
> >
> >But that can be on top of this series as the way I use it:
> >
> >   make -j8 -C tools/perf/ O=/home/git/build/perf install
> >
> >still works as expected.
> 
> Does this sequence still work?
> 
> cd tools/perf
> make O=/tmp/pbuild
> 
> and the O= is honored?

Yes:

[acme@sandy linux]$ mkdir /tmp/perf
[acme@sandy linux]$ cd tools/perf
[acme@sandy perf]$ make O=/tmp/perf
    MKDIR /tmp/perf/arch/x86/util
<SNIP>
    MKDIR /tmp/perf/util/ui/browsers
PERF_VERSION = perf.core.for.mingo.6.gea01fa
    GEN /tmp/perf/common-cmds.h
    * new build flags or prefix
    CC /tmp/perf/perf.o
    CC /tmp/perf/builtin-annotate.o
<SNIP>
    CC /tmp/perf/util/parse-options.o
    BISON event-parser
    FLEX event-parser
    BISON pmu-parser
    FLEX pmu-parser
    CC /tmp/perf/util/parse-events.o
<SNIP>
    AR /tmp/perf/libperf.a
    LINK /tmp/perf/perf
    GEN perf-archive
    GEN /tmp/perf/python/perf.so
[acme@sandy perf]$ 
[acme@sandy perf]$ /tmp/perf/perf --version
perf version perf.core.for.mingo.6.gea01fa
[acme@sandy perf]$

- Arnaldo
