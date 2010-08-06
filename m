Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab0HFOaP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 10:30:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:36704 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab0HFOaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 10:30:12 -0400
Date: Fri, 6 Aug 2010 11:29:45 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Joe Perches <joe@perches.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 05/10] perf hists: Fixup addr snprintf width on 32 bit
	arches
Message-ID: <20100806142945.GC17509@ghostprotocols.net>
References: <1281059177-18747-1-git-send-email-acme@infradead.org> <1281059177-18747-6-git-send-email-acme@infradead.org> <1281059887.19943.23.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281059887.19943.23.camel@Joe-Laptop.home>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Aug 05, 2010 at 06:58:07PM -0700, Joe Perches escreveu:
> On Thu, 2010-08-05 at 22:46 -0300, Arnaldo Carvalho de Melo wrote:
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > By using BITS_PER_LONG/4 as the width specifier.
> []
> > diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
> > index 1c61a4f..b62a553 100644
> > --- a/tools/perf/util/sort.c
> > +++ b/tools/perf/util/sort.c
> []
> > -		ret += repsep_snprintf(bf, size, "%#018llx %c ", self->ip, o);
> > +		ret += repsep_snprintf(bf, size, "%*Lx %c ",
> > +				       BITS_PER_LONG / 4, self->ip, o);
> []
> > -		ret += repsep_snprintf(bf + ret, size - ret, "%#016llx", self->ip);
> > +		ret += repsep_snprintf(bf + ret, size - ret, "%*Lx",
> > +				       BITS_PER_LONG / 4, self->ip);
> 
> This drops leading 0's.

Is this a problem? This removes clutter from the output, right?

- Arnaldo
