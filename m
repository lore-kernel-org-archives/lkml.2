Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab2GWSPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 14:15:19 -0400
Received: from shutemov.name ([176.9.204.213]:44225 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085Ab2GWSPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 14:15:18 -0400
Date: Mon, 23 Jul 2012 21:16:08 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf: fix build error
Message-ID: <20120723181608.GA24558@shutemov.name>
References: <1343055645-24083-1-git-send-email-kirill@shutemov.name>
 <20120723180244.GB5418@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120723180244.GB5418@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 08:02:44PM +0200, Arnaldo Carvalho de Melo wrote:
> Em Mon, Jul 23, 2012 at 06:00:44PM +0300, Kirill A. Shutemov escreveu:
> > From: "Kirill A. Shutemov" <kirill@shutemov.name>
> > 
> > util/parse-events.c:29:5: error: redundant redeclaration of ‘parse_events_parse’ [-Werror=redundant-decls]
> > In file included from util/parse-events.c:14:0:
> > util/parse-events-bison.h:99:5: note: previous declaration of ‘parse_events_parse’ was here
> > cc1: all warnings being treated as errors
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> 
> Causes the build to fail for me:
> 
> [acme@sandy linux]$ make -j8 -C tools/perf/ O=/home/acme/git/build/perf install
> make: Entering directory `/home/git/linux/tools/perf'
> PERF_VERSION = 3.5.rc7.235.g5e5fcb
> make: Leaving directory `/home/git/linux/tools/perf'
> make: Entering directory `/home/git/linux/tools/perf'
>     GEN perf-archive
> make[1]: Entering directory `/home/git/linux/tools/lib/traceevent'
>     CC /home/acme/git/build/perf/perf.o
>     CC /home/acme/git/build/perf/util/parse-events.o
> make[2]: warning: jobserver unavailable: using -j1.  Add `+' to parent make rule.
>     CC /home/acme/git/build/perf/util/map.o
>     CC /home/acme/git/build/perf/util/session.o
>     CC /home/acme/git/build/perf/util/trace-event-parse.o
> make[2]: `libtraceevent.a' is up to date.
> make[1]: Leaving directory `/home/git/linux/tools/lib/traceevent'
> cc1: warnings being treated as errors
> util/parse-events.c: In function ‘parse_events__scanner’:
> util/parse-events.c:701: error: implicit declaration of function ‘parse_events_parse’
> util/parse-events.c:701: error: nested extern declaration of ‘parse_events_parse’
> make: *** [/home/acme/git/build/perf/util/parse-events.o] Error 1
> make: *** Waiting for unfinished jobs....
> make: Leaving directory `/home/git/linux/tools/perf'
> [acme@sandy linux]$ 

What bison version do you have?

-- 
 Kirill A. Shutemov
