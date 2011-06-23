Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370Ab1FWMD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 08:03:56 -0400
Received: from smtp-out.google.com ([74.125.121.67]:11145 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759336Ab1FWMDy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 08:03:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WIsDP9JVSqRW7QkxIhSCeFiKIuUqbrrglYKyUYvxCBzjW2JsAbpNZpN6S4gSqAbPq7
         XqSjaQIyLX5hz7+Brybg==
MIME-Version: 1.0
In-Reply-To: <20110623115327.GG10238@sun>
References: <BANLkTim8OdhTdaayHZAKSXWhmN0anEhieQ@mail.gmail.com>
	<20110621183227.GG21641@sun>
	<20110622082756.GK21641@sun>
	<20110622092134.GO21641@sun>
	<20110623064835.GB10238@sun>
	<BANLkTikVaOz5DYjKSU-jxVBw_Lw9ihV7BQ@mail.gmail.com>
	<20110623095439.GC10238@sun>
	<20110623110706.GE10238@sun>
	<20110623114055.GV3765@redhat.com>
	<BANLkTikR7j0iZ7SLsfkz=2bpTm2uaO_=5g@mail.gmail.com>
	<20110623115327.GG10238@sun>
Date: Thu, 23 Jun 2011 14:03:50 +0200
Message-ID: <BANLkTin5sN2FZaQYsnsEkH10OF-GES9MGw@mail.gmail.com>
Subject: Re: [RFC -tip] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event v2
From: Stephane Eranian <eranian@google.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vweaver1@eecs.utk.edu>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 1:53 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Thu, Jun 23, 2011 at 01:44:36PM +0200, Stephane Eranian wrote:
>> On Thu, Jun 23, 2011 at 1:40 PM, Don Zickus <dzickus@redhat.com> wrote:
>> > On Thu, Jun 23, 2011 at 03:07:06PM +0400, Cyrill Gorcunov wrote:
>> >> On Thu, Jun 23, 2011 at 01:54:39PM +0400, Cyrill Gorcunov wrote:
>> >> ...
>> >> > >
>> >> > > No new hidden event, just a x86_pmu + a per-arch callbacks.
>> >> >
>> >> > Looks quite good for me, Don? (i'll cook some draft patch for review meanwhile).
>> >> >
>> >> >     Cyrill
>> >>
>> >> Since we are going to make __weak linking anyway maybe something like below
>> >> fit even beter? (untested)
>> >
>> > I don't think the compiler knows what platform you are running on and may
>> > just blindly link your new p4 function for all x86s, which is probably not
>> > what you want.
>> >
>> Don, is right. You need the level of indirection I had in my outline patch.
>>
>> You also don't need the:
>> +       if (wd_attr->type       != PERF_TYPE_HARDWARE ||
>> +          wd_attr->attr.config != PERF_COUNT_HW_CPU_CYCLES)
>> +               return;
>>
>> In the p4 callback given you know your coming in for the watchdog.
>>
>
> Yes, that is why in __weak implementation I dropped it. So guys,
> what we stick with -- __weak with second level indirection?
>
No, first level in watchdog.c, the other callback has to be implemented
from x86_pmu as you had it.

>        Cyrill
>
