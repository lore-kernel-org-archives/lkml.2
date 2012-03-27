Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab2C0SQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 14:16:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57497 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab2C0SP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 14:15:59 -0400
Date: Tue, 27 Mar 2012 15:15:47 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC] perf tools: Including pre-generated flex files
Message-ID: <20120327181547.GA7374@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

	We now use lex and bison for the events and PMU parser:

[acme@sandy linux]$ wc -l tools/perf/util/*.[yl]
  126 tools/perf/util/parse-events.l
  229 tools/perf/util/parse-events.y
   43 tools/perf/util/pmu.l
   93 tools/perf/util/pmu.y
  491 total

	Jiri and Peter agreed on having pre-generated files:

[acme@sandy linux]$ wc -l tools/perf/util/*-{bison,flex}.[ch]
  1917 tools/perf/util/parse-events-bison.c
    81 tools/perf/util/parse-events-bison.h
  1663 tools/perf/util/pmu-bison.c
    73 tools/perf/util/pmu-bison.h
  2272 tools/perf/util/parse-events-flex.c
   316 tools/perf/util/parse-events-flex.h
  1821 tools/perf/util/pmu-flex.c
   316 tools/perf/util/pmu-flex.h
  8459 total

so that we don't require even more tools to build the kernel, following
the precedent of:

[acme@sandy linux]$ wc -l scripts/*/*.[ch]_shipped
  1976 scripts/dtc/dtc-lexer.lex.c_shipped
  1946 scripts/dtc/dtc-parser.tab.c_shipped
    86 scripts/dtc/dtc-parser.tab.h_shipped
   220 scripts/genksyms/keywords.hash.c_shipped
  2245 scripts/genksyms/lex.lex.c_shipped
  2399 scripts/genksyms/parse.tab.c_shipped
    95 scripts/genksyms/parse.tab.h_shipped
   286 scripts/kconfig/zconf.hash.c_shipped
  2420 scripts/kconfig/zconf.lex.c_shipped
  2504 scripts/kconfig/zconf.tab.c_shipped
 14177 total
[acme@sandy linux]$

	But Ingo argues that flex and bison are just a yum/whatever
install away, so we shouldn't clutter the kernel git history with things
we can generate at build time.

	What is your take on this?

- Arnaldo
