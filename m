Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab1CJAuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 19:50:10 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46659 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab1CJAuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 19:50:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Yh8SgdcTWxH2KSJJ78+26QBNxnYwLDDZjOFRmzaE0babVHFvFTDnGghWehcCQe5u57
         8A/LVlSn5xiCz+hxSg9OyT1MqbLau8Tf58osGiESYkLxI7bbrICjIDrUnRPXJQzwrH0a
         00r/fCTGqixLN3IRvnbfE2lgEe4Typ/Qbid0Q=
Date: Thu, 10 Mar 2011 01:50:03 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <daahern@cisco.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 07/10] perf script: Move printing of 'common' data from
 print_event and rename
Message-ID: <20110310005001.GF2533@nowhere>
References: <1299695491-15786-1-git-send-email-acme@infradead.org>
 <1299695491-15786-8-git-send-email-acme@infradead.org>
 <20110309235007.GB2533@nowhere>
 <4D78158F.6010403@cisco.com>
 <20110310001039.GC2533@nowhere>
 <4D78174B.2090209@cisco.com>
 <20110310002240.GE2533@nowhere>
 <4D781C16.3080706@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D781C16.3080706@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 05:32:22PM -0700, David Ahern wrote:
> 
> 
> On 03/09/11 17:22, Frederic Weisbecker wrote:
> > On Wed, Mar 09, 2011 at 05:15:00PM -0700, David Ahern wrote:
> >>
> >>
> >> On 03/09/11 17:10, Frederic Weisbecker wrote:
> >>>
> >>> And if you actually keep those functions in place?
> >>
> >>     CC /tmp/build-perf/util/trace-event-read.o
> >> cc1: warnings being treated as errors
> >> util/trace-event-parse.c:2652:13: error: 'print_graph_cpu' defined but
> >> not used
> >> util/trace-event-parse.c:2681:13: error: 'print_graph_proc' defined but
> >> not used
> >> make: *** [/tmp/build-perf/util/trace-event-parse.o] Error 1
> >> make: *** Waiting for unfinished jobs....
> > 
> > All right, that's because you removed their calls in pretty_print_func_ent().
> > So either you remove the whole in a specific patch, pretty_print_func_ent()
> > included and other related functions, or you keep them.
> > 
> > But I prefer we don't do something halfway, and in particular not in a
> > semi-hidden way inside a patch that is not particularly focused on that
> > purpose.
> 
> You lost me on the halfway part.
> 
> So you want a separate patch that removes the code for an incomplete
> feature -- which means changing the references to the functions in that
> patch?

Yep.

> The intent being a patch that can be reverted later?

That can be reverted or something on top of which we can refer to
get that feature later.

In any case it is deadcode right now. If you remove it it should be
better done seperately. For all the reasons we always prefer to have
patches that do only one logic thing: easier to review, understand,
bisect, revert, find a bug, explain it, etc...

Ok, in fact you can actually keep it like you did: remove the cpu and
proc displays and let the rest of the function graph features. But
at least do it in an isolated patch because that should not be
an unnoticeable change, and for other reasons to make it a standalone
patch quoted above.
