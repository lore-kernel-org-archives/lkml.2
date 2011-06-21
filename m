Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179Ab1FURKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 13:10:13 -0400
Received: from smtp-out.google.com ([216.239.44.51]:19870 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab1FURKH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 13:10:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pHfMwGMRRGglmFD/6fqUmmrz6YZGjd0Z3ueQCXGBPHy7cwvpqxV9g6W27Huqcp5K7Q
         7zwyX/7C9uP+lGI5CVxg==
MIME-Version: 1.0
In-Reply-To: <20110621164820.GC21641@sun>
References: <4DB989B5.1030703@openvz.org>
	<20110621152301.GA5155@redhat.com>
	<BANLkTi=zPq81nScodFcPxcLSrTGPNA1HWA@mail.gmail.com>
	<1308671933.26237.183.camel@twins>
	<BANLkTim-2p1DgV1XD_J2vH514aL_KuFaEQ@mail.gmail.com>
	<BANLkTikxWV8tjXrZnOrNnsw+nmsjGaxWbw@mail.gmail.com>
	<20110621164820.GC21641@sun>
Date: Tue, 21 Jun 2011 19:10:05 +0200
Message-ID: <BANLkTink5nOTqvqQYr4kx0fnBoOpoq7CiQ@mail.gmail.com>
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

On Tue, Jun 21, 2011 at 6:48 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Tue, Jun 21, 2011 at 06:20:56PM +0200, Stephane Eranian wrote:
>> Cyrill,
>> [repost because of MIME crap]
>
> I saw first as well, sorry for delay, my isp is broken today :/
>
>>
>> I admit I don't quite understand how this patch works around
>> the limitation. In the end you are still going to program some cycle
>> event into a P4 PMU register. So how it is going to free more counters
>> for regular users?
>>
>>
>
>  The key here is that we use that named non-sleeping ticks (as oprofile
> did) for nmi-watchdog and it allows us to free "cpu-cycles" counter for
> user needs. Of course we pick up one counter for this but it doesn't intersect
> with "cpu-cycles" counter (because counters are grouped and can count only
> specified events in each group). Stepane, should I post more details?
>
Ok, so you're using a different PMU event for the watchdog. But then, in this
case why not simply change kernel/watchdog.c to hardcode something specific
for P4, i.e, change the wd_hw_attr.config/type fields to match the
event you want.
You could create a arch specific callback to setup config/type.

I don't think it makes sense to expose yet another generic PMU event, especially
given the name you gave to it and what it actually does. People might wonder
what good is that for?
