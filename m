Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab2BGKb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 05:31:28 -0500
Received: from mail-lpp01m020-f174.google.com ([209.85.217.174]:39194 "EHLO
	mail-lpp01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753063Ab2BGKb0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 05:31:26 -0500
MIME-Version: 1.0
In-Reply-To: <1328610322.2232.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <20120206205354.GA31186@quad>
	<1328603689.2476.15.camel@edumazet-laptop>
	<20120207084156.GA15359@elte.hu>
	<1328610322.2232.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Date: Tue, 7 Feb 2012 11:31:24 +0100
Message-ID: <CABPqkBTL70n-e9TZo=QOZDk1J84Ye5wGrm6uz=VNu73nwwxhjw@mail.gmail.com>
Subject: Re: [PATCH] perf: fix assertion failure in x86_pmu_start()
From: Stephane Eranian <eranian@google.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, markus@trippelsdorf.de, paulus@samba.org
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 7, 2012 at 11:25 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le mardi 07 février 2012 à 09:41 +0100, Ingo Molnar a écrit :
>
>> Were these messages introduced by:
>>
>>  e050e3f0a71b: perf: Fix broken interrupt rate throttling
>>
>> as well?
>>
>> In any case I'm holding off on applying the patch before this is
>> resolved.
>
> Reverting e050e3f0a71b solves all my problems, no more warnings.
>
> $ perf record -a -g hackbench 10 thread 4000
> Running with 10*40 (== 400) tasks.
> Time: 13.181
> [ perf record: Woken up 59 times to write data ]
> [ perf record: Captured and wrote 16.874 MB perf.data (~737228 samples)
> ]
>
> $ perf record -a -g hackbench 10 thread 4000
> Running with 10*40 (== 400) tasks.
> Time: 13.124
> [ perf record: Woken up 61 times to write data ]
> [ perf record: Captured and wrote 16.533 MB perf.data (~722349 samples)
> ]
>
What system is this running on?
The problem is that without e050e3f0a71b interrupt throttling does not work.

I think the key difference is that without the patch, frequency adjustment
happens with the PMU completely stopped whereas with my patch it does
not. I suspect this may be the issue. I can rework the patch to disable the
PMU completely while retaining the same workflow.
