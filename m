Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab0HBOwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 10:52:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:53454 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab0HBOwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 10:52:30 -0400
Date: Mon, 2 Aug 2010 11:52:18 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, paulus@samba.org
Subject: Re: [PATCH v2] Re: perf annotate segfaults when source code has goto
 label that looks like hex number
Message-ID: <20100802145218.GG12166@ghostprotocols.net>
References: <20100722072044.GD27177@redhat.com>
 <20100722143345.GC17631@ghostprotocols.net>
 <20100722163851.GA10307@redhat.com>
 <20100722164711.GD17631@ghostprotocols.net>
 <20100722165222.GE17631@ghostprotocols.net>
 <20100722170541.GF17631@ghostprotocols.net>
 <20100722180538.GB10307@redhat.com>
 <20100722191132.GG17631@ghostprotocols.net>
 <1280739734.1923.20.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280739734.1923.20.camel@laptop>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 02, 2010 at 11:02:14AM +0200, Peter Zijlstra escreveu:
> On Thu, 2010-07-22 at 16:11 -0300, Arnaldo Carvalho de Melo wrote:
> > > > diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> > > > @@ -976,13 +976,15 @@ static int hist_entry__parse_objdump_line(struct hist_entry *self, FILE *file,
> > > >     if (line_ip != -1) {
> > > >             u64 start = map__rip_2objdump(self->ms.map, sym->start);
> > > >             offset = line_ip - start;
> > > > +           if (offset < 0 || (u64)line_ip > sym->end)
> > > > +                   offset = -1;
> > 
> > > This part is good idea anyway. Even if label will be interpreted as ip
> > > perf at least will not crash. It may miss-report something if check will
> > > accidentally succeed though.
> > 
> > Yeah, we can possibly find a label which is a valid hex number and that
> > falls inside the address range, but with what we have in objdump this
> > seems to be the best we can have, I'll commit this.
> 
> Wouldn't it be better to re-write perf-annotate to not have wild monkey
> sex with objdump and instead 'borrow' some of the objdump code to
> generate the output ourselves? That way we don't rely on the output
> syntax at all..

Right, the problem is that doing that seems like avoiding regular,
mostly satisfying sex with a known partner to having a month long orgy
blindfold.  You can try, I'll pass for now.

- Arnaldo
