Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172Ab0HQSSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 14:18:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:32786 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758130Ab0HQSSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 14:18:51 -0400
Date: Tue, 17 Aug 2010 15:18:35 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Kusanagi Kouichi <slash@ac.auone-net.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix build error on read only source.
Message-ID: <20100817181835.GA21083@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Bad-Reply: 'Re:' in Subject but no References or In-Reply-To headers
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Aug 17, 2010 at 11:17:54AM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Tue, Aug 17, 2010 at 11:08:40PM +0900, Kusanagi Kouichi escreveu:
> > --- a/tools/perf/feature-tests.mak
> > +++ b/tools/perf/feature-tests.mak
> > @@ -113,7 +113,7 @@ endef
> >  # try-cc
> >  # Usage: option = $(call try-cc, source-to-build, cc-options)
> >  try-cc = $(shell sh -c						  \
> > -	'TMP="$(TMPOUT).$$$$";			 		  \
> > +	'TMP="$(OUTPUT)$(TMPOUT).$$$$";				  \
> >  	 echo "$(1)" |						  \
> >  	 $(CC) -x c - $(2) -o "$$TMP" > /dev/null 2>&1 && echo y; \
> >  	 rm -f "$$TMP"')
> 
> Much better! Will test and merge, thanks!

Still has issues:

[acme@emilia linux-2.6-tip]$ rm -rf ~/git/build/perf/
[acme@emilia linux-2.6-tip]$ make O=~/git/build/perf -s -j9 -C tools/perf install
PERF_VERSION = 2.6.36.rc1.2.g19bad
    * new build flags or prefix
[acme@emilia linux-2.6-tip]$ patch -p1 < Kouichi.patch 
patching file tools/perf/Makefile
patching file tools/perf/feature-tests.mak
[acme@emilia linux-2.6-tip]$ rm -rf ~/git/build/perf/
[acme@emilia linux-2.6-tip]$ make O=~/git/build/perf -s -j9 -C tools/perf install
Makefile:503: No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev
Makefile:534: *** No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static.  Stop.
[acme@emilia linux-2.6-tip]$

Can you please investigate?

Thanks,

- Arnaldo
