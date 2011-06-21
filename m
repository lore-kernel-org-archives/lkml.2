Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab1FUTsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 15:48:51 -0400
Received: from smtp-out.google.com ([216.239.44.51]:29140 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab1FUTst convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 15:48:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=CjL/Y6B3XP2eKj1BpA/hEhyWe3xYsrW/IZXTQlWoMOeH53OzWALAaTTsQlNF3sr/QX
         ID6ba3tBsZN3WvS/iV7Q==
MIME-Version: 1.0
In-Reply-To: <20110615053716.GA390@linux.vnet.ibm.com>
References: <20110503092846.022272244@google.com> <20110607154542.GA2991@linux.vnet.ibm.com>
 <1307529966.4928.8.camel@dhcp-10-30-22-158.sw.ru> <20110608163234.GA23031@linux.vnet.ibm.com>
 <BANLkTim7a9uhH_K6sw4YdqWB6frT+HUqqQ@mail.gmail.com> <20110610181719.GA30330@linux.vnet.ibm.com>
 <BANLkTimE1b8HP-q4jgsv5jPD5S-dRoUi_g@mail.gmail.com> <20110615053716.GA390@linux.vnet.ibm.com>
From: Paul Turner <pjt@google.com>
Date: Tue, 21 Jun 2011 12:48:17 -0700
Message-ID: <BANLkTi=7S2qdVjbJkDja+GAoD=pNo2gPsTFZMFkB8NWWkO1JVQ@mail.gmail.com>
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned vs unpinned
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Pavel Emelianov <xemul@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamalesh,

Can you see what things look like under v7?

There's been a few improvements to quota re-distribution that should
hopefully help your test case.

The remaining idle% I see on my machines appear to be a product of
load-balancer inefficiency.

Thanks!

- Paul

On Tue, Jun 14, 2011 at 10:37 PM, Kamalesh Babulal
<kamalesh@linux.vnet.ibm.com> wrote:
> * Paul Turner <pjt@google.com> [2011-06-13 17:00:08]:
>
>> Hi Kamalesh.
>>
>> I tried on both friday and again today to reproduce your results
>> without success.  Results are attached below.  The margin of error is
>> the same as the previous (2-level deep case), ~4%.  One minor nit, in
>> your script's input parsing you're calling shift; you don't need to do
>> this with getopts and it will actually lead to arguments being
>> dropped.
>>
>> Are you testing on top of a clean -tip?  Do you have any custom
>> load-balancer or scheduler settings?
>>
>> Thanks,
>>
>> - Paul
>>
>>
>> Hyper-threaded topology:
>> unpinned:
>> Average CPU Idle percentage 38.6333%
>> Bandwidth shared with remaining non-Idle 61.3667%
>>
>> pinned:
>> Average CPU Idle percentage 35.2766%
>> Bandwidth shared with remaining non-Idle 64.7234%
>> (The mask in the "unpinned" case is 0-3,6-9,12-15,18-21 which should
>> mirror your 2 socket 8x2 configuration.)
>>
>> 4-way NUMA topology:
>> unpinned:
>> Average CPU Idle percentage 5.26667%
>> Bandwidth shared with remaining non-Idle 94.73333%
>>
>> pinned:
>> Average CPU Idle percentage 0.242424%
>> Bandwidth shared with remaining non-Idle 99.757576%
>>
> Hi Paul,
>
> I tried tip 919c9baa9 + V6 patchset on 2 socket,quadcore with HT and
> the Idle time seen is ~22% to ~23%. Kernel is not tuned to any custom
> load-balancer/scheduler settings.
>
> unpinned:
> Average CPU Idle percentage 23.5333%
> Bandwidth shared with remaining non-Idle 76.4667%
>
> pinned:
> Average CPU Idle percentage 0%
> Bandwidth shared with remaining non-Idle 100%
>
> Thanks,
>
>  Kamalesh
>>
>>
>>
>> On Fri, Jun 10, 2011 at 11:17 AM, Kamalesh Babulal
>> <kamalesh@linux.vnet.ibm.com> wrote:
>> > * Paul Turner <pjt@google.com> [2011-06-08 20:25:00]:
>> >
>> >> Hi Kamalesh,
>> >>
>> >> I'm unable to reproduce the results you describe.  One possibility is
>> >> load-balancer interaction -- can you describe the topology of the
>> >> platform you are running this on?
>> >>
>> >> On both a straight NUMA topology and a hyper-threaded platform I
>> >> observe a ~4% delta between the pinned and un-pinned cases.
>> >>
>> >> Thanks -- results below,
>> >>
>> >> - Paul
>> >>
>> >>
> (snip)
>
