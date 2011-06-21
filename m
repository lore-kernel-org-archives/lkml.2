Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab1FUR0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 13:26:25 -0400
Received: from smtp-out.google.com ([216.239.44.51]:26528 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab1FUR0Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 13:26:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XTYtvF+V1fSYWh7q+QBfZRC5inixRoGPV4IV9YjXWI4Kl0mNVNlAmjfIY4J1fO3sSZ
         qwovuN0CLaX14sskFYDg==
MIME-Version: 1.0
In-Reply-To: <20110621172319.GE21641@sun>
References: <4DB989B5.1030703@openvz.org>
	<20110621152301.GA5155@redhat.com>
	<BANLkTi=zPq81nScodFcPxcLSrTGPNA1HWA@mail.gmail.com>
	<1308671933.26237.183.camel@twins>
	<BANLkTim-2p1DgV1XD_J2vH514aL_KuFaEQ@mail.gmail.com>
	<BANLkTikxWV8tjXrZnOrNnsw+nmsjGaxWbw@mail.gmail.com>
	<20110621164820.GC21641@sun>
	<BANLkTink5nOTqvqQYr4kx0fnBoOpoq7CiQ@mail.gmail.com>
	<20110621172319.GE21641@sun>
Date: Tue, 21 Jun 2011 19:26:16 +0200
Message-ID: <BANLkTikBsfcFfnmgdVQem15P9f2ooQBzeA@mail.gmail.com>
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

On Tue, Jun 21, 2011 at 7:23 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Tue, Jun 21, 2011 at 07:10:05PM +0200, Stephane Eranian wrote:
> ...
>> >
>> >  The key here is that we use that named non-sleeping ticks (as oprofile
>> > did) for nmi-watchdog and it allows us to free "cpu-cycles" counter for
>> > user needs. Of course we pick up one counter for this but it doesn't intersect
>> > with "cpu-cycles" counter (because counters are grouped and can count only
>> > specified events in each group). Stepane, should I post more details?
>> >
>> Ok, so you're using a different PMU event for the watchdog. But then, in this
>> case why not simply change kernel/watchdog.c to hardcode something specific
>> for P4, i.e, change the wd_hw_attr.config/type fields to match the
>> event you want.
>
>  It doesn't change things much. Of course I can put some specifics into
> .config but where is the guarantee some new generic event would not ever
> intersect with it. I know (for example) we could reserve -1ULL for this
> event but again where is the guarantee that it will never ever be used
> system wide in future for some different event?
>
I am not talking about a new generic PMU event. I am talking about
you hardcoding a raw event in the callback: type = PERF_TYPE_RAW,
config=0x003c.

> So I need some event-id in which I may be sure it will never be
> used for different purpose.
>
>> You could create a arch specific callback to setup config/type.
>>
>> I don't think it makes sense to expose yet another generic PMU event, especially
>> given the name you gave to it and what it actually does. People might wonder
>> what good is that for?
>
>        Cyrill
>
