Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab1EWMj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 08:39:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35257 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab1EWMj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 08:39:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YYSxobZW7hHHt1NTnMCR9hCk42rIkqZ1q0Ctm3N6W/X/mAeLF65CVXJGPUGeNgBip3
         +mdxV64W2ZwdUM25hsklsuGXWp8yf3tda+MisG76IZ04++GUiKQYW/ulGNiNOjixunOZ
         +zHwctQqaCCI+YaVp74CO9+eXI5oUXH2Zwm5M=
Date: Mon, 23 May 2011 14:39:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf tools: Fix sample size bit operations
Message-ID: <20110523123919.GF1728@nowhere>
References: <1306148788-6179-1-git-send-email-fweisbec@gmail.com>
 <1306148788-6179-2-git-send-email-fweisbec@gmail.com>
 <20110523112815.GA4042@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110523112815.GA4042@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 01:28:15PM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > What we want is to count the number of bits in the mask,
> > not some other random operation written in the middle
> > of the night.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: Stephane Eranian <eranian@google.com>
> > ---
> >  tools/perf/util/event.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
> > index 17c1c3c..d3fa7e4 100644
> > --- a/tools/perf/util/event.c
> > +++ b/tools/perf/util/event.c
> > @@ -42,7 +42,7 @@ int perf_sample_size(u64 sample_type)
> >  	int i;
> >  
> >  	for (i = 0; i < 64; i++) {
> > -		if ((mask << i) & 1)
> > +		if (mask & (1 << i))
> >  			size++;
> >  	}
> 
> I fixed this to be 1UL and applied your fixes out of email - perf top and perf 
> report works fine now, so this was a 64-bitness bug (you probably used a 32-bit 
> system for testing?).

Nope I was using a 64 machine for testing, but I only tested sched_switch
events with callchains on perf report and perf script.

Perhaps that bug triggered only on perf top or with default cpu-cycle events.

> 
> Btw., shouldnt this use hweight() or such?

A real proper way would better have that yeah :)
