Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab2BGL1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 06:27:37 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59131 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755279Ab2BGL1g convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 06:27:36 -0500
MIME-Version: 1.0
In-Reply-To: <1328613886.3443.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <20120206205354.GA31186@quad>
	<1328603689.2476.15.camel@edumazet-laptop>
	<20120207084156.GA15359@elte.hu>
	<1328610322.2232.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<CABPqkBTL70n-e9TZo=QOZDk1J84Ye5wGrm6uz=VNu73nwwxhjw@mail.gmail.com>
	<1328610997.2232.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<CABPqkBRwjwG0i+J_Qzgm+khHRD+LiT60vMEQA3w1MtPq-FFKLw@mail.gmail.com>
	<1328613886.3443.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Date: Tue, 7 Feb 2012 12:27:34 +0100
Message-ID: <CABPqkBRM1u=+5gKs1i02LSDMGrZDoDiDkBxVrjtsQYkVCRkFsw@mail.gmail.com>
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

On Tue, Feb 7, 2012 at 12:24 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le mardi 07 février 2012 à 11:40 +0100, Stephane Eranian a écrit :
>> Eric,
>>
>> How do you deal with that:
>>
>> [    0.019998] Performance Events: PEBS fmt0+, Core2 events, Broken
>> BIOS detected, complain to your hardware vendor.
>> [    0.019998] [Firmware Bug]: the BIOS has corrupted hw-PMU resources
>> (MSR 186 is 43003c)
>>
>> Your BIOS is using a counter to count cycles for power savings tricks.
>> That is conflicting
>> with perf_events.
>
> This was already discussed last year.
>
> https://lkml.org/lkml/2011/3/24/552
>
> Apparently all HP blades I have in my labs have the problem, whatever
> option is chosen in BIOS.
>
> On my machines, I set the BIOS to 'High performance', and cpus are on
> highest available frequencies.
>
>
Yeah, it's an old problem (> 4years). And if I recall correctly, there
is no option in
the BIOS to turn it off. You'd have to talk to HP directly.
