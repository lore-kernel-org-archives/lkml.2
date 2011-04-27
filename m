Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab1D0OrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 10:47:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50163 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab1D0OrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 10:47:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Mtt9J7XE2ZMpEsu3hHCqpOhAWKnQqvn18R4Q68+spopUeqsZcuRdUzpZTRFi3BUyDw
         d9bcuEf/tLe3B4rHLOkv+/bLs1lgtIxsIq5SGqrPCM1BsnXhgWYuxI6HXffThehxMqEr
         yBP6leemdqzK/W/lTsJim/swUGhr//s3qHtG0=
MIME-Version: 1.0
In-Reply-To: <20110427111141.GB28993@elte.hu>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
	<20110422092322.GA1948@elte.hu>
	<BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
	<20110422105211.GB1948@elte.hu>
	<20110422165007.GA18401@vps.sharma-home.net>
	<20110422203022.GA20573@elte.hu>
	<20110423201409.GA20072@elte.hu>
	<20110424061645.GA12013@radium.snc4.facebook.com>
	<20110427111141.GB28993@elte.hu>
Date: Wed, 27 Apr 2011 07:47:02 -0700
X-Google-Sender-Auth: SHfBpKkIpELHY1DR9c3BSpiU8Fo
Message-ID: <BANLkTimz-KevvqmxxUPp73GEaAC5PTGWWw@mail.gmail.com>
Subject: Re: [PATCH] perf events: Add stalled cycles generic event - PERF_COUNT_HW_STALLED_CYCLES
From: Arun Sharma <arun@sharma-home.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arun Sharma <asharma@fb.com>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 4:11 AM, Ingo Molnar <mingo@elte.hu> wrote:
> As for the first, 'overview' step, i'd like to use one or two numbers only, to
> give people a general ballpark figure about how good the CPU is performing for
> a given workload.
>
> Wouldnt UOPS_EXECUTED.CORE_ACTIVE_CYCLES,c=1,i=1 be in general a pretty good,
> primary "stall" indicator? This is similar to the "cycles-uops_executed" value
> in your script (UOPS_EXECUTED:PORT015:t=1 and UOPS_EXECUTED:PORT234_CORE
> based): it counts cycles when there's no execution at all - not even
> speculative one.

If we're going to pick one stall indicator, why not pick cycles where
no uops are retiring?

cycles_no_uops_retired = cycles - c["UOPS_RETIRED:ANY:c=1:t=1"]

In the presence of C-states and some halted cycles, I found that I
couldn't measure it via UOPS_RETIRED:ANY:c=1:i=1 because it counts
halted cycles too and could be greater than (unhalted) cycles.

The other issue I had to deal with was UOPS_RETIRED > UOPS_EXECUTED
condition. I believe this is caused by what AMD calls sideband stack
optimizer and Intel calls dedicated stack manager (i.e. UOPS executed
outside the main pipeline). A recursive fibonacci(30) is a good test
case for reproducing this.

>
> Is this the direction you'd like to see perf stat to move into? Any comments,
> suggestions?
>

Looks like a step in the right direction. Thanks.

 -Arun
