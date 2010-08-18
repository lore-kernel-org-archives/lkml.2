Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab0HROQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 10:16:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33066 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab0HROQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 10:16:22 -0400
Date: Wed, 18 Aug 2010 11:16:11 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix build error on read only source.
Message-ID: <20100818141611.GE9410@ghostprotocols.net>
References: <20100817181835.GA21083@ghostprotocols.net>
 <20100818123713.1F02414C03B@msa103.auone-net.jp>
 <1282135224.1926.3936.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282135224.1926.3936.camel@laptop>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 18, 2010 at 02:40:24PM +0200, Peter Zijlstra escreveu:
> On Wed, 2010-08-18 at 21:37 +0900, Kusanagi Kouichi wrote:
> 
> > With POSIX shell patch, $(OUTPUT) has not been created yet when it is
> > used by try-cc. This fixes the issue anyway.
> > 
> > diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> > index dcb9700..5b1c12b 100644
> > --- a/tools/perf/Makefile
> > +++ b/tools/perf/Makefile
> > @@ -281,6 +281,7 @@ endif
> > 
> >  -include feature-tests.mak
> > 
> > +$(shell mkdir -p $(OUTPUT) 2> /dev/null)
> >  ifeq ($(call try-cc,$(SOURCE_HELLO),-Werror -fstack-protector-all),y)
> >  	CFLAGS := $(CFLAGS) -fstack-protector-all
> >  endif

> So you're wanting to provide a non-existing O=foo ?
> 
> I don't think we should, simply bail when it doesn't exist, kernel
> builds do the same:
> 
> # make O=plop-build bzImage
> /bin/sh: line 0: cd: plop-build: No such file or directory
> Makefile:117: *** output directory "plop-build" does not exist.  Stop.

Agreed that making it work like the kernel brings less surprises, but
isn't it convenient to be able to just do:

rm -rf ~/build
make O=~/build

and have everything work? Saving some keystrokes 8)

- Arnaldo
