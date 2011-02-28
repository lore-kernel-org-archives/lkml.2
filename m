Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab1B1Oqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 09:46:33 -0500
Received: from smtp-out.google.com ([74.125.121.67]:42393 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab1B1Oqc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 09:46:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cMjk8Rj3onajxUDeL3hD4rw9p1g2h1U2vwbxJs7crPLGNDLhJhWs8I9sZOyg6x5aqZ
         reIdMaz0V/ENR0KwPAfg==
MIME-Version: 1.0
In-Reply-To: <1298904325.2169.54.camel@localhost>
References: <1298877772.4937.25.camel@minggr.sh.intel.com>
	<1298884559.2428.10083.camel@twins>
	<1298902887.2169.48.camel@localhost>
	<1298903087.2428.10875.camel@twins>
	<1298904325.2169.54.camel@localhost>
Date: Mon, 28 Feb 2011 15:46:28 +0100
Message-ID: <AANLkTim4Lxu9diPQQ15Rv-esBU_uCLVPDiuwFaXA6hKK@mail.gmail.com>
Subject: Re: [PATCH v2 -tip] perf: x86, add SandyBridge support
From: Stephane Eranian <eranian@google.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 3:45 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> On Mon, 2011-02-28 at 22:24 +0800, Peter Zijlstra wrote:
>> On Mon, 2011-02-28 at 22:21 +0800, Lin Ming wrote:
>> > > >  #define INTEL_EVENT_CONSTRAINT(c, n)       \
>> > > >     EVENT_CONSTRAINT(c, n, ARCH_PERFMON_EVENTSEL_EVENT)
>> > > > +#define INTEL_EVENT_CONSTRAINT2(c, n)      \
>> > > > +   EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
>> > >
>> > > That's a particularly bad name, how about something like
>> > >
>> > > INTEL_UEVENT_CONSTRAINT or somesuch.
>> >
>> > OK.
>> >
>> > But any case it's duplicated with PEBS_EVENT_CONSTRAINT.
>> >
>> > #define PEBS_EVENT_CONSTRAINT(c, n)     \
>> >         EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
>>
>> Ah, indeed, so maybe we can remove PEBS_EVENT_CONSTRAINT and use regular
>> INTEL_*_CONSTRAINTS there, that could also help for PEBS events where
>> all umasks are allowed (not sure there are any such things but the SNB
>> PEBS list was quite large).
>
> Yes, there are, for example, BR_INST_RETIRED.*
>
I think most of the time all umasks are allowed.

>
