Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab2BFVZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 16:25:52 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59306 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755740Ab2BFVZu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 16:25:50 -0500
MIME-Version: 1.0
In-Reply-To: <1328561890.2482.39.camel@laptop>
References: <CABPqkBTutb5TuNVXZ4o+MzXczVSwk3NtsJh73KZS58xmrd=tbg@mail.gmail.com>
	<20120204135110.GA6437@elte.hu>
	<CABPqkBTvoNBBdzvS-njoFk+SrTf-BKQSvP54C05un+m7RA+nBg@mail.gmail.com>
	<CABPqkBQdRwKKAvgK339Po0-WBW-MJkgcmpWqS=OOgepn3_XiRw@mail.gmail.com>
	<1328523130.2220.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<CABPqkBQLn+5fYtOjhpKjXSzvKesuo+YRXxaawyTGUTQuZ6AjYw@mail.gmail.com>
	<1328526691.2220.16.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<CABPqkBQnDToQczbgW4dCXiu3x2ZTXjAuKS_q_hJ=28Pu_2HexQ@mail.gmail.com>
	<20120206143844.GA23807@elte.hu>
	<CABPqkBR2nydKxU91NUaoKSUX2w+hN4ZFCi1khHPvMLB+Rid33A@mail.gmail.com>
	<20120206154700.GA13478@elte.hu>
	<CABPqkBQPYvEu58TDPwDNV-ydpooe-yY924w4FnsEiK9DKEdJ2Q@mail.gmail.com>
	<1328561890.2482.39.camel@laptop>
Date: Mon, 6 Feb 2012 22:25:48 +0100
Message-ID: <CABPqkBR2xBT-+sMw0+u3gTjpE1g+MgnghH+BBvi34XiXL+181g@mail.gmail.com>
Subject: Re: WARNING: at arch/x86/kernel/cpu/perf_event.c:989
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 6, 2012 at 9:58 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Mon, 2012-02-06 at 21:44 +0100, Stephane Eranian wrote:
>> Which is pointing to the Intel specific:
>>
>> intel_pmu_handle_irq()
>> again:
>>         intel_pmu_ack_status(status);
>>         if (++loops > 100) {
>>                 WARN_ONCE(1, "perfevents: irq loop stuck!\n");
>>                 perf_event_print_debug();
>>                 intel_pmu_reset();
>>                 goto done;
>>         }
>>
>> We are in a constant interrupt loop for a reason I don't yet understand.
>> Sure we have two counters going, bu given the callstack, one is being
>> stopped.
>>
>> I know we talked about that a couple of weeks back, but after all, it may
>> be that it is not possible to run the frequency adjustment code without
>> stopping the entire PMU because of risk of interrupts. But it is not clear
>> to me what's causing this at this point.
>
> There's Errata's on this, see AAK157 (SNB) BD106 (WSM) AAK157 (NHM).
>
Arg, I had forgotten about those.....
I'll check on this further with Intel.

> Ingo and I talked about a 'fix' for that based on the text in the SNB
> errata which explains why the reset works. Ingo I was under the
> impression you were going to implement that?
>
>> I suggest we still apply my patch to fix the x86_pmu_start() first, then
>> I will submit a second patch to fix that one. Agreed?
>
> Yes.
>
