Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab2GFBIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 21:08:43 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47238 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab2GFBIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 21:08:41 -0400
MIME-Version: 1.0
In-Reply-To: <1341404019.2507.107.camel@laptop>
References: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
	<1341352848-11833-8-git-send-email-jolsa@redhat.com>
	<1341398360.2507.99.camel@laptop>
	<20120704120001.GC960@krava.redhat.com>
	<1341404019.2507.107.camel@laptop>
Date: Fri, 6 Jul 2012 03:08:39 +0200
Message-ID: <CABPqkBQk7+8D9S3kAqRBz6qMZ1_Vi88XXgNF1PGb89t5bP=NRg@mail.gmail.com>
Subject: Re: [PATCH 07/10] perf, tool: Add support to specify hw event as pmu
 event term
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 4, 2012 at 2:13 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2012-07-04 at 14:00 +0200, Jiri Olsa wrote:
>> On Wed, Jul 04, 2012 at 12:39:20PM +0200, Peter Zijlstra wrote:
>> > On Wed, 2012-07-04 at 00:00 +0200, Jiri Olsa wrote:
>> > >
>> > > It's possible to use sysfs attribute name as 'event' term value,
>> > > or any possible alias for hw event, e.g.:
>> > >   cycles                     OR cpu-cycles
>> > >   branch_misses              OR branch-misses
>> > >   bus_cycles                 OR bus-cycles
>> > >   cache_misses               OR cache-misses
>> > >   cache_references           OR cache-references
>> > >   ref_cycles                 OR ref-cycles
>> > >   stalled_cycles_backend     OR stalled-cycles-backend
>> > >   stalled_cycles_frontend    OR stalled-cycles-frontend
>> >
>> > Do we really want to do that?
>>
>> well, the aliasing works on sysfs filename base.. so when you specify
>>    event=str
>>
>> 'str' file is looked up in 'events' dir.
>
> Right..
>
>> We use '_' in file names and '-' in event symbol names. I thought it might be
>> confusing allowing just '_' so I added also the '-' version.
>>
What's wrong with keeping the - in the filenames as well? That would help
keep things simple. That would avoid yet another layer of aliases.


>> I could keep just the '-' version.. with some more work on kernel ATTR
>> function names ;) but it seems like common sysfs practise to use '_'.
>
> We could map '-' to '_', but I'm not sure about the aliases in general.
> I mean if the sysfs event name is 'cycles' also allowing 'cpu_cycles' is
> somewhat confusing and arbitrary.
>
> I think it would be best to stick to discoverable names only. Anybody?
>
>
