Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151Ab1BAO21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 09:28:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:37131 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757043Ab1BAO2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 09:28:24 -0500
Date: Tue, 1 Feb 2011 12:28:11 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/5] perf/core improvements
Message-ID: <20110201142811.GA20938@ghostprotocols.net>
References: <1296509362-28054-1-git-send-email-acme@infradead.org>
 <20110201091447.GA27297@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201091447.GA27297@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Feb 01, 2011 at 10:14:47AM +0100, Ingo Molnar escreveu:
> 
> * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> 
> > Hi Ingo,
> > 
> >         Please consider pulling from:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core
> > 
> 
> Pulled, thanks Arnaldo!
> 
> Note, there's a beauty wart i noticed, while building perf on 32-bit Fedora: the build output
> includes new, unintended lines:
> 
>     CC util/scripting-engines/trace-event-perl.o
>     CC scripts/perl/Perf-Trace-Util/Context.o
>     CC util/scripting-engines/trace-event-python.o
>     CC scripts/python/Perf-Trace-Util/Context.o
>     CC perf.o
>     CC builtin-help.o
> gcc -pthread -fno-strict-aliasing -DNDEBUG -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m32 -march=i686 -mtune=atom -fasynchronous-unwind-tables -D_GNU_SOURCE -fPIC -fwrapv -fPIC -Iutil/include -I/usr/include/python2.6 -c util/evlist.c -o temp.linux-i686-2.6/util/evlist.o -fno-strict-aliasing -Wno-write-strings
> gcc -pthread -fno-strict-aliasing -DNDEBUG -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m32 -march=i686 -mtune=atom -fasynchronous-unwind-tables -D_GNU_SOURCE -fPIC -fwrapv -fPIC -Iutil/include -I/usr/include/python2.6 -c util/evsel.c -o temp.linux-i686-2.6/util/evsel.o -fno-strict-aliasing -Wno-write-strings

Yeah, I noticed that too, its on my todo list, its the setup.py python
building part, I need to either make it silent and provide just one:

PYTHON perf.so

message or to ditch using setup.py and do everything directly, which I
may need to do anyway because 'python setup.py --build-base" (or
equivalent, that I haven't found) doesn't work with 'install', just with
'build'.

For now its just a nuisance, not something crucial, but I'll get that
nailed.

- Arnaldo
