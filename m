Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab0CZRLk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 13:11:40 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:60222 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab0CZRLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 13:11:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Pa45tCCK/xnEfrW1eUYORv2vfh0xyJmoH70Txb55NZkT43cTJxWEM8QsijeQFhXN/a
         2LBBW6LMVQQWI2DP1ItqIuwnspPsEmF2G96UWu07Nut7K57I9V8ERAY0PoMShHpRLjxi
         z1U/IMywtbaonRCfi/CXrbx5qOTOFyjEot1Qk=
Date: Fri, 26 Mar 2010 18:11:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] lockdep: Make lockstats counting per cpu
Message-ID: <20100326171130.GB5188@nowhere>
References: <1269570142-13965-1-git-send-regression-fweisbec@gmail.com> <1269573118-11120-1-git-send-regression-fweisbec@gmail.com> <20100326091639.GG27394@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100326091639.GG27394@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 10:16:39AM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > +DEFINE_PER_CPU(local_t, chain_lookup_hits);
> > +DEFINE_PER_CPU(local_t, chain_lookup_misses);
> > +DEFINE_PER_CPU(local_t, hardirqs_on_events);
> > +DEFINE_PER_CPU(local_t, hardirqs_off_events);
> > +DEFINE_PER_CPU(local_t, redundant_hardirqs_on);
> > +DEFINE_PER_CPU(local_t, redundant_hardirqs_off);
> > +DEFINE_PER_CPU(local_t, softirqs_on_events);
> > +DEFINE_PER_CPU(local_t, softirqs_off_events);
> > +DEFINE_PER_CPU(local_t, redundant_softirqs_on);
> > +DEFINE_PER_CPU(local_t, redundant_softirqs_off);
> > +DEFINE_PER_CPU(local_t, nr_unused_locks);
> > +DEFINE_PER_CPU(local_t, nr_cyclic_checks);
> > +DEFINE_PER_CPU(local_t, nr_find_usage_forwards_checks);
> > +DEFINE_PER_CPU(local_t, nr_find_usage_backwards_checks);
> 
> btw., i think this should really be cleaned up and put into a helper struct.
> 
> 'struct lockdep_stats' or so?



Yep, looks like a good idea.

