Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab1CaG62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 02:58:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58378 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756910Ab1CaG61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 02:58:27 -0400
Date: Thu, 31 Mar 2011 08:58:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Robin Holt <holt@sgi.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC 2/2] Make x86 calibrate_delay run in parallel.
Message-ID: <20110331065805.GG5938@elte.hu>
References: <20101215015840.390204279@gulag1.americas.sgi.com>
 <20101215015849.051095242@gulag1.americas.sgi.com>
 <AANLkTinoctZFKo4wBmrrdFggnjSj74QfqvEpz59sW15x@mail.gmail.com>
 <20110331065036.GC5938@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110331065036.GC5938@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
> > On Tue, Dec 14, 2010 at 5:58 PM,  <Robin@sgi.com> wrote:
> > >
> > > On a 4096 cpu machine, we noticed that 318 seconds were taken for bringing
> > > up the cpus.  By specifying lpj=<value>, we reduced that to 75 seconds.
> > > Andi Kleen suggested we rework the calibrate_delay calls to run in
> > > parallel.  With that code in place, a test boot of the same machine took
> > > 61 seconds to bring the cups up.  I am not sure how we beat the lpj=
> > > case, but it did outperform.
> > >
> > > One thing to note is the total BogoMIPS value is also consistently higher.
> > > I am wondering if this is an effect with the cores being in performance
> > > mode.  I did notice that the parallel calibrate_delay calls did cause the
> > > fans on the machine to ramp up to full speed where the normal sequential
> > > calls did not cause them to budge at all.
> > 
> > please check attached patch, that could calibrate correctly.
> > 
> > Thanks
> > 
> > Yinghai
> 
> > [PATCH -v2] x86: Make calibrate_delay run in parallel.
> > 
> > On a 4096 cpu machine, we noticed that 318 seconds were taken for bringing
> > up the cpus.  By specifying lpj=<value>, we reduced that to 75 seconds.
> > Andi Kleen suggested we rework the calibrate_delay calls to run in
> > parallel.
> 
> The risk wit tat suggestion is that it will spectacularly miscalibrate on 
> hyperthreading systems.

s/wit tat/with that

Thanks,

	Ingo
