Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab2BFU6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 15:58:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:32848 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab2BFU6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 15:58:17 -0500
Subject: Re: WARNING: at arch/x86/kernel/cpu/perf_event.c:989
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>
In-Reply-To: <CABPqkBQPYvEu58TDPwDNV-ydpooe-yY924w4FnsEiK9DKEdJ2Q@mail.gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Feb 2012 21:58:10 +0100
Message-ID: <1328561890.2482.39.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-06 at 21:44 +0100, Stephane Eranian wrote:
> Which is pointing to the Intel specific:
> 
> intel_pmu_handle_irq()
> again:
>         intel_pmu_ack_status(status);
>         if (++loops > 100) {
>                 WARN_ONCE(1, "perfevents: irq loop stuck!\n");
>                 perf_event_print_debug();
>                 intel_pmu_reset();
>                 goto done;
>         }
> 
> We are in a constant interrupt loop for a reason I don't yet understand.
> Sure we have two counters going, bu given the callstack, one is being
> stopped.
> 
> I know we talked about that a couple of weeks back, but after all, it may
> be that it is not possible to run the frequency adjustment code without
> stopping the entire PMU because of risk of interrupts. But it is not clear
> to me what's causing this at this point.

There's Errata's on this, see AAK157 (SNB) BD106 (WSM) AAK157 (NHM).

Ingo and I talked about a 'fix' for that based on the text in the SNB
errata which explains why the reset works. Ingo I was under the
impression you were going to implement that?

> I suggest we still apply my patch to fix the x86_pmu_start() first, then
> I will submit a second patch to fix that one. Agreed? 

Yes.

