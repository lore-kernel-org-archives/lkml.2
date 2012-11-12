Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab2KLQES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 11:04:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56263 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab2KLQER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 11:04:17 -0500
Date: Mon, 12 Nov 2012 13:04:09 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 10/21] perf hists: Introduce hists__link
Message-ID: <20121112160409.GD18978@ghostprotocols.net>
References: <1352497390-17716-1-git-send-email-acme@infradead.org>
 <1352497390-17716-11-git-send-email-acme@infradead.org>
 <87y5i7mtl2.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y5i7mtl2.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 12, 2012 at 11:40:57AM +0900, Namhyung Kim escreveu:
> On Fri,  9 Nov 2012 18:42:59 -0300, Arnaldo Carvalho de Melo wrote:
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>

> > That given two hists will find the hist_entries (buckets) in the second
> > hists that are for the same bucket in the first and link them, then it
> > will look for all buckets in the second that don't have a counterpart in
> > the first and will create a dummy counterpart that will then be linked
> > to the entry in the second.

> > For multiple events this will be done pairing the leader with all the
> > other events in the group, so that in the end the leader will have all
> > the buckets in all the hists in a group, dummy or not while the other
> > hists will be left untouched.
> [snip]
> > +	he = hist_entry__new(pair);
> > +	if (he) {
> > +		he->stat.nr_events = 0;
> > +		he->stat.period    = 0;
> 
> What about other fields?
> Why not use "memset(&he->stat, 0, sizeof(he->stat))" for this?

Right, will do.

- Arnaldo
