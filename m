Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934205Ab2FHKD5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 06:03:57 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54310 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab2FHKDz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 06:03:55 -0400
MIME-Version: 1.0
In-Reply-To: <1339149613.23343.52.camel@twins>
References: <20120607071531.GA4849@quad>
	<1339064319.23343.13.camel@twins>
	<CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
	<1339065932.23343.18.camel@twins>
	<CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
	<1339067757.23343.21.camel@twins>
	<20120608093513.GA22520@gmail.com>
	<1339149613.23343.52.camel@twins>
Date: Fri, 8 Jun 2012 12:03:49 +0200
Message-ID: <CABPqkBSFgyJS4QEg6MmrF=96GFeH=z_4GvuC2nCHQ8RJaw298w@mail.gmail.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on SandyBridge
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, mingo@elte.hu, ming.m.lin@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 8, 2012 at 12:00 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2012-06-08 at 11:35 +0200, Ingo Molnar wrote:
>> * Peter Zijlstra <peterz@infradead.org> wrote:
>>
>> > On Thu, 2012-06-07 at 12:48 +0200, Stephane Eranian wrote:
>> > > >> The warning could also be done on boot. But the check has to be done
>> > > >>  when the event is created.
>> > > >
>> > > > Is this because of the ucode loader not having done its thing yet etc..?
>> >
>> > Ah, its because you can update ucode at runtime of course.
>> >
>> > A quick look at the ucode loader doesn't show it having a
>> > notifier either, so then yeah we need to check on every event
>> > creation :/
>> >
>> > Or we could put a hook in the ucode loader.
>>
>> I'd really suggest the latter - I doubt this will be our only
>> ucode dependent quirk, going forward ...
>
> Yeah, am in the middle of writing that..

I am fine with that. As I found out yesterday, the reality is that the
ucode version for SNB vs. SNB-EP differ, so with this mechanism
we could customize the callback per CPU model number more easily.
