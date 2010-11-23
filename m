Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab0KWKAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 05:00:51 -0500
Received: from smtp-out.google.com ([216.239.44.51]:52789 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab0KWKAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 05:00:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=o8au/Gnfly2ueTb1q5lhuNi8A5bklvMR4r4lyKH/rIc4FELZJF+isC2MYV1eYQmsEo
         1HSeLcjy78vgAd4ZmCoQ==
MIME-Version: 1.0
In-Reply-To: <1290361473.2153.39.camel@laptop>
References: <1290340877.2245.124.camel@localhost>
	<8e9ff9280b0c4a059bc82b5c4a629897.squirrel@www.firstfloor.org>
	<1290348259.2245.172.camel@localhost>
	<1290361473.2153.39.camel@laptop>
Date: Tue, 23 Nov 2010 11:00:46 +0100
Message-ID: <AANLkTik2_VLiKfZNC3BJeFnqS8kp7bMOg6qhJ1yPGmej@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3 v2] perf: Implement Nehalem uncore pmu
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Lin Ming <ming.m.lin@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 6:44 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Sun, 2010-11-21 at 22:04 +0800, Lin Ming wrote:
>> On Sun, 2010-11-21 at 20:46 +0800, Andi Kleen wrote:
>> > >
>> > > 2. Uncore pmu NMI handling
>> > >
>> > > All the 4 cores are programmed to receive uncore counter overflow
>> > > interrupt. The NMI handler(running on 1 of the 4 cores) handle all
>> > > counters enabled by all 4 cores.
>> >
>> > Really for uncore monitoring there is no need to use an NMI handler.
>> > You can't profile a core anyways, so you can just delay the reporting
>> > a little bit. It may simplify the code to not use one here
>> > and just use an ordinary handler.
>>
>> OK, I can use on ordinary interrupt handler here.
>
> Does the hardware actually allow using a different interrupt source?
>
It does not. It's using whatever you've programmed into the APIC
LVT vector, AFAIK. Uncore interrupt mode is enabled via
IA32_DEBUGCTL. Regarless of sampling or not, you need the interrupt
to virtualize the counters to 64 bits.
