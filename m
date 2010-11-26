Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab0KZLZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 06:25:56 -0500
Received: from smtp-out.google.com ([74.125.121.35]:12798 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab0KZLZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 06:25:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=sNlipDGalH+J/V1J5UNWVi5CduwHxiDDpf7ahX3TJC+pIfYD7VBdXAyaO5/5UQqzJf
         b0b0vXVVRbVuEYa7OBUQ==
MIME-Version: 1.0
In-Reply-To: <1290770652.2145.128.camel@laptop>
References: <1290340877.2245.124.camel@localhost>
	<AANLkTikt8AkZjNahrzTStJ5qM0D4Z+H_7snZBgsABm24@mail.gmail.com>
	<AANLkTimzEDXzF=hMzmNCvsPok1kqxd0vjNKuYur_+J5L@mail.gmail.com>
	<AANLkTimN6_v6VibsNU70kV_QUnF4Fj0=M=Akp8aASE-3@mail.gmail.com>
	<1290770652.2145.128.camel@laptop>
Date: Fri, 26 Nov 2010 12:25:51 +0100
Message-ID: <AANLkTika3r2=gCh4nX-raRU3BoFpWMUEapn3w2bgyGAd@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3 v2] perf: Implement Nehalem uncore pmu
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Lin Ming <lin@ming.vg>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 12:24 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Fri, 2010-11-26 at 09:18 +0100, Stephane Eranian wrote:
>
>> In the perf_event model, given that any one of the 4 cores can be used
>> to program uncore events, you have no choice but to broadcast to all
>> 4 cores. Each has to demultiplex and figure out which of its counters
>> have overflowed.
>
> Not really, you can redirect all these events to the first online cpu of
> the node.
>
> You can re-write event->cpu in pmu::event_init(), and register cpu
> hotplug notifiers to migrate the state around.
>
I am sure you could. But then the user thinks the event is controlled
from CPUx when it's actually from CPUz. I am sure it can work but
that's confusing, especially interrupt-wise.
