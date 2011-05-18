Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892Ab1ERLIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 07:08:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49112 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932125Ab1ERLIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 07:08:12 -0400
Date: Wed, 18 May 2011 13:07:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v1 5/5] KVM: Expose a version 1 architectural PMU to
 guests
Message-ID: <20110518110759.GB16556@elte.hu>
References: <1305129333-7456-1-git-send-email-avi@redhat.com>
 <1305129333-7456-6-git-send-email-avi@redhat.com>
 <20110517194117.GA26184@elte.hu>
 <4DD38B57.2070904@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD38B57.2070904@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> >>  - some combinations of INV and CMASK are not supported
> >
> > Could you please describe this better, where does this limit come from? If 
> > perf then this needs fixing.
> 
> perf_event_attr does not support generic INV and CMASK at all. [...]

It does through raw events - which are indeed model specific.

> [...]  I imagine you can get them through the model-specific hardware 
> configuration, but that means we have to encode model specific information 
> into kvm host code, which is (a) hard (b) counter to the spirit of perf.
> 
> (INV and CMASK allow you to increment the counter only when > N or <
> N events occur simultaneously, for example count when 2 or more
> instructions are retired in a single clock).

Peter, what do you think about adding a inv and cmask attribute that is applied 
to generic events automatically?

I *think* it should work just out of box: we recognize the fixed-purpose 
counter events based on their raw value, so if one comes in with inv and cmask 
set it will just be scheduled on a generic hw counter.

> >  - we could do things like propagate guest side traces over to the host
> 
> We support that already via 'perf kvm', no? [...]

Not without usability issues, if you remember that flamewa^W thread! :-)

> [...] This is more about the guest profiling itself without access to the 
> host (which is the more common scenario, IMO).

Correct - so there would be interactions with virtio-perf. I think the two will 
just have to be made to mix well, that's all.

> We're still missing tunnelling guest ftrace to the host, but a patch was 
> recently posted to do that.

If you tunnel guest perf events then ftrace events are included automatically.  
That's the primary/unified event transport model we are working towards.

Thanks,

	Ingo
