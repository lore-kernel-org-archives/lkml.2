Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab2GDJOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 05:14:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48057 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab2GDJN4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 05:13:56 -0400
Message-ID: <1341393205.23484.111.camel@twins>
Subject: Re: [PATCH] perf, x86: Enabled PEBS event to be exported in a raw
 format
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Feng Tang <feng.tang@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>,
        Robert Richter <robert.richter@amd.com>
Date: Wed, 04 Jul 2012 11:13:25 +0200
In-Reply-To: <1341389237.22063.7.camel@concordia>
References: <1340899250-26803-1-git-send-email-feng.tang@intel.com>
	 <1341300987.11663.15.camel@concordia> <1341306905.23484.53.camel@twins>
	 <1341389237.22063.7.camel@concordia>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 18:07 +1000, Michael Ellerman wrote:
> Basically we have three registers which provide various information about
> the instruction which caused an event to overflow.
> 
> The first reports the address of the instruction, the second the data
> address associated with the instruction, and the third reports "other
> stuff".
> 
> We use the first for SAMPLE_IP, and the second for SAMPLE_ADDR, but
> currently we have no way of spitting out the third register.
> 
> There's a whole bunch of info in there. I think the most interesting are
> stuff like whether and where in the pipeline the instruction stalled, or
> where a load was serviced from. I'm not sure to be honest, so I've asked
> the HW guys what they're most interested in.
> 
> So I can imagine us coming up with a generic sample type for "sample
> other info at event overflow", but I'm struggling to see how we'd make
> the content of the sample non architecture specific, or even processor
> version specific. 

Right so we're working on a data-source like thing, the last attempt at
adding something like that is in this thread:

 http://marc.info/?l=linux-kernel&m=130987553915170&w=2
 http://marc.info/?l=linux-kernel&m=131000375226044

I think Stephane is currently trying to revive that, although he hasn't
posted yet. Please have a look if that captures the possible PPC states
as well. Stephane could you share your current stuff so Michael can have
a look?


Not quite sure what to do for your pipeline stage thing, I'm not sure
I've seen that elsewhere.


Anyway, yes PERF_SAMPLE_RAW is the 'other info at overflow' which is
specific to the current cpu and phase of moon type field, and it does
get (ab)used in various places, but I still cringe every time I see it
used.

The problem with that thing is that it gives people the data they need
for their special tools and thus removes them from the incentive pool to
help create more generic,useful tools.

For AMD IBS we've given in since that thing is completely weird, IIRC
Robert was going to grow perf-ibs to record and report the data it
captures so we've at least got a useful open-source tool for it.
