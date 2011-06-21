Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab1FUSG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 14:06:59 -0400
Received: from smtp-out.google.com ([74.125.121.67]:21272 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab1FUSG6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 14:06:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ib4S5rc3mc+BXjxXVw4k+N4e42ekYm9YV7+f6fNeS1gq6+qTpoWZQY27+cQZ2B0YHc
         MkHW5iMZZtSK2Fw3K9zQ==
MIME-Version: 1.0
In-Reply-To: <20110621175421.GF21641@sun>
References: <4DB989B5.1030703@openvz.org>
	<20110621152301.GA5155@redhat.com>
	<BANLkTi=zPq81nScodFcPxcLSrTGPNA1HWA@mail.gmail.com>
	<1308671933.26237.183.camel@twins>
	<BANLkTim-2p1DgV1XD_J2vH514aL_KuFaEQ@mail.gmail.com>
	<BANLkTikxWV8tjXrZnOrNnsw+nmsjGaxWbw@mail.gmail.com>
	<20110621164820.GC21641@sun>
	<BANLkTink5nOTqvqQYr4kx0fnBoOpoq7CiQ@mail.gmail.com>
	<20110621172319.GE21641@sun>
	<BANLkTikBsfcFfnmgdVQem15P9f2ooQBzeA@mail.gmail.com>
	<20110621175421.GF21641@sun>
Date: Tue, 21 Jun 2011 20:06:54 +0200
Message-ID: <BANLkTim8OdhTdaayHZAKSXWhmN0anEhieQ@mail.gmail.com>
Subject: Re: [RFC -tip] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event v2
From: Stephane Eranian <eranian@google.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Don Zickus <dzickus@redhat.com>,
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

On Tue, Jun 21, 2011 at 7:54 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Tue, Jun 21, 2011 at 07:26:16PM +0200, Stephane Eranian wrote:
> ...
>> >
>> >  It doesn't change things much. Of course I can put some specifics into
>> > .config but where is the guarantee some new generic event would not ever
>> > intersect with it. I know (for example) we could reserve -1ULL for this
>> > event but again where is the guarantee that it will never ever be used
>> > system wide in future for some different event?
>> >
>> I am not talking about a new generic PMU event. I am talking about
>> you hardcoding a raw event in the callback: type = PERF_TYPE_RAW,
>> config=0x003c.
>>
>
> watchdog.c is system-wide and even if it's not used by archs other
> than x86 doesn't mean it'll not in future ;) So we could encode
> this watchdog event as you mention (and I would check for this
> values and map it internally to bits I need, this btw will require me
> to check if this bits do not intersect with some already valid bits
> combination but it's a different problem) but than we _must_ be sure it
> never bring problems as new arch or consumer appear. So, no, I don't
> like this approach, it's fragile. But gimme some time -- I'll re-check
> all bits, probably there is some workaround.
>
I don't understand what possible conflict bits you're talking about

If in arch/x86/kernel/cpu/perf_event.c I add a callback which
checks:

    if (netburst_host) {
       attr.type = PERF_TYPE_RAW
       attr.config = 0x3c
   } else {
      attr.type = PERF_TYPE_HARDWARE
      attr.config = PERF_COUNT_HW__CPU_CYCLES
  }

I simply don't think PERF_COUNT_HW_NMI_WATCHDOG should
ever be exposed to users.

>        Cyrill
>
