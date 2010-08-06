Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761527Ab0HFPfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 11:35:39 -0400
Received: from mail.perches.com ([173.55.12.10]:2306 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761450Ab0HFPff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 11:35:35 -0400
Subject: Re: [PATCH 05/10] perf hists: Fixup addr snprintf width on 32 bit
 arches
From: Joe Perches <joe@perches.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
In-Reply-To: <20100806142945.GC17509@ghostprotocols.net>
References: <1281059177-18747-1-git-send-email-acme@infradead.org>
	 <1281059177-18747-6-git-send-email-acme@infradead.org>
	 <1281059887.19943.23.camel@Joe-Laptop.home>
	 <20100806142945.GC17509@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Aug 2010 08:35:32 -0700
Message-ID: <1281108932.17033.27.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-06 at 11:29 -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Aug 05, 2010 at 06:58:07PM -0700, Joe Perches escreveu:
> > On Thu, 2010-08-05 at 22:46 -0300, Arnaldo Carvalho de Melo wrote:
> > > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > > By using BITS_PER_LONG/4 as the width specifier.
> > []
> > > diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
> > > index 1c61a4f..b62a553 100644
> > > --- a/tools/perf/util/sort.c
> > > +++ b/tools/perf/util/sort.c
> > []
> > > -		ret += repsep_snprintf(bf, size, "%#018llx %c ", self->ip, o);
> > > +		ret += repsep_snprintf(bf, size, "%*Lx %c ",
> > > +				       BITS_PER_LONG / 4, self->ip, o);
> > []
> > > -		ret += repsep_snprintf(bf + ret, size - ret, "%#016llx", self->ip);
> > > +		ret += repsep_snprintf(bf + ret, size - ret, "%*Lx",
> > > +				       BITS_PER_LONG / 4, self->ip);
> > 
> > This drops leading 0's.
> 
> Is this a problem? This removes clutter from the output, right?

Dunno, you made an output that looked like a pointer address,

64 bit:

"0x0123456789abcdef" now is " 123456789abcdef"

32 bit:

"0x0000000001234567" now is " 1234567"

snprintf(loc, size, "%#0*lx", BITS_PER_LONG / 4 + 2, (long))
might be better.

snprintf(loc, size, "%p", (void)long)
might be best.





