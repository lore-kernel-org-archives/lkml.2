Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab0HBJC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 05:02:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:38108 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab0HBJC0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 05:02:26 -0400
Subject: Re: [PATCH v2] Re: perf annotate segfaults when source code has
 goto label that looks like hex number
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, paulus@samba.org
In-Reply-To: <20100722191132.GG17631@ghostprotocols.net>
References: <20100722072044.GD27177@redhat.com>
	 <20100722143345.GC17631@ghostprotocols.net>
	 <20100722163851.GA10307@redhat.com>
	 <20100722164711.GD17631@ghostprotocols.net>
	 <20100722165222.GE17631@ghostprotocols.net>
	 <20100722170541.GF17631@ghostprotocols.net>
	 <20100722180538.GB10307@redhat.com>
	 <20100722191132.GG17631@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 02 Aug 2010 11:02:14 +0200
Message-ID: <1280739734.1923.20.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-22 at 16:11 -0300, Arnaldo Carvalho de Melo wrote:
> > > diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> > > @@ -976,13 +976,15 @@ static int hist_entry__parse_objdump_line(struct hist_entry *self, FILE *file,
> > >     if (line_ip != -1) {
> > >             u64 start = map__rip_2objdump(self->ms.map, sym->start);
> > >             offset = line_ip - start;
> > > +           if (offset < 0 || (u64)line_ip > sym->end)
> > > +                   offset = -1;
> 
> > This part is good idea anyway. Even if label will be interpreted as ip
> > perf at least will not crash. It may miss-report something if check will
> > accidentally succeed though.
> 
> Yeah, we can possibly find a label which is a valid hex number and that
> falls inside the address range, but with what we have in objdump this
> seems to be the best we can have, I'll commit this.

Wouldn't it be better to re-write perf-annotate to not have wild monkey
sex with objdump and instead 'borrow' some of the objdump code to
generate the output ourselves? That way we don't rely on the output
syntax at all..
