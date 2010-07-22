Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716Ab0GVTQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 15:16:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758236Ab0GVTQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 15:16:48 -0400
Date: Thu, 22 Jul 2010 22:16:30 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org
Subject: Re: [PATCH v2] Re: perf annotate segfaults when source code has
 goto label that looks like hex number
Message-ID: <20100722191630.GC10307@redhat.com>
References: <20100722072044.GD27177@redhat.com>
 <20100722143345.GC17631@ghostprotocols.net>
 <20100722163851.GA10307@redhat.com>
 <20100722164711.GD17631@ghostprotocols.net>
 <20100722165222.GE17631@ghostprotocols.net>
 <20100722170541.GF17631@ghostprotocols.net>
 <20100722180538.GB10307@redhat.com>
 <20100722191132.GG17631@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100722191132.GG17631@ghostprotocols.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 04:11:32PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Jul 22, 2010 at 09:05:38PM +0300, Gleb Natapov escreveu:
> > On Thu, Jul 22, 2010 at 02:05:42PM -0300, Arnaldo Carvalho de Melo wrote:
> > > Em Thu, Jul 22, 2010 at 01:52:22PM -0300, Arnaldo Carvalho de Melo escreveu:
> > > > Em Thu, Jul 22, 2010 at 01:47:11PM -0300, Arnaldo Carvalho de Melo escreveu:
> > > > It could be a comment of play code, like:
> 
> > > >       while(1) {
> > > >               if (++i == 10000000)
> > > >                       goto add;
> > > >       }
> > > > add:	return 0;
> 
> > > What about this one?
> 
> > > diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> > > @@ -976,13 +976,15 @@ static int hist_entry__parse_objdump_line(struct hist_entry *self, FILE *file,
> > >  	if (line_ip != -1) {
> > >  		u64 start = map__rip_2objdump(self->ms.map, sym->start);
> > >  		offset = line_ip - start;
> > > +		if (offset < 0 || (u64)line_ip > sym->end)
> > > +			offset = -1;
> 
> > This part is good idea anyway. Even if label will be interpreted as ip
> > perf at least will not crash. It may miss-report something if check will
> > accidentally succeed though.
> 
> Yeah, we can possibly find a label which is a valid hex number and that
> falls inside the address range, but with what we have in objdump this
> seems to be the best we can have, I'll commit this.
> 
Agree. Definitely better that what we have now. Thanks.

--
			Gleb.
