Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028Ab1I2XGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 19:06:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60616 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab1I2XGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 19:06:21 -0400
Date: Thu, 29 Sep 2011 20:06:13 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, a.p.zijlstra@chello.nl, mingo@elte.hu,
        paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Exit recording if events have non matching
	sample type
Message-ID: <20110929230613.GA20083@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Bad-Reply: 'Re:' in Subject but no References or In-Reply-To headers
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 29, 2011 at 04:55:23PM -0600, David Ahern escreveu:
> On 09/29/2011 04:05 PM, Arnaldo Carvalho de Melo wrote:
> > Em Thu, Sep 29, 2011 at 06:01:08PM +0200, Jiri Olsa escreveu:
> >> Following command hangs on my setup:
> >>   ./perf record -o perf.data -e ext4:ext4_mb_new_group_pa \
> >>    -e LLC-loads -- date '+%F'
> >>
> >> because hardware and tracepoint events have different sample type.
> >>
> >> With the patch applied the record command displays
> >> "Non matching sample_type" message and exits.
> > 
> > That is way too cryptic :-\
> > 
> > What is that makes the sample type not match in this case? Can we make
> > it match instead?
> > 
> > This is something to be properly fixed by _allowing_ non matching sample
> > types, the evsel/evlist abstractions are getting we close but not there
> > yet, multiple files in a perf.data/ directory are needed.
> 
> >From what I can see sample_type has to be the same for all samples:
> https://lkml.org/lkml/2011/8/15/6

We could add a PERF_SAMPLE_ID2 that if present would be guaranteed to be
the last, or we can, as PeterZ prefers/suggests, to use one mmap per
sample id, then we know that if we're getting it on that mmap, it has
that sample_type.

For record that means we need to dump each per-sample_id mmap onto a
separate file, i.e. use a directory, etc.

But what I suggested as a short term solution was to check what is the
difference in the above case and then make them use a single sample
type, i.e. bow to the current restriction.

- Arnaldo

