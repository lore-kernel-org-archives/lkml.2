Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933621Ab1CaJh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 05:37:27 -0400
Received: from relay2.sgi.com ([192.48.179.30]:52988 "HELO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S933184Ab1CaJhY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 05:37:24 -0400
Date: Thu, 31 Mar 2011 04:37:23 -0500
From: Robin Holt <holt@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Robin Holt <holt@sgi.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC 2/2] Make x86 calibrate_delay run in parallel.
Message-ID: <20110331093723.GE24046@sgi.com>
References: <20101215015840.390204279@gulag1.americas.sgi.com>
 <20101215015849.051095242@gulag1.americas.sgi.com>
 <AANLkTinoctZFKo4wBmrrdFggnjSj74QfqvEpz59sW15x@mail.gmail.com>
 <20110331065036.GC5938@elte.hu>
 <20110331065805.GG5938@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110331065805.GG5938@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 08:58:05AM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> > > On Tue, Dec 14, 2010 at 5:58 PM,  <Robin@sgi.com> wrote:
> > > >
> > > > On a 4096 cpu machine, we noticed that 318 seconds were taken for bringing
> > > > up the cpus.  By specifying lpj=<value>, we reduced that to 75 seconds.
> > > > Andi Kleen suggested we rework the calibrate_delay calls to run in
> > > > parallel.  With that code in place, a test boot of the same machine took
> > > > 61 seconds to bring the cups up.  I am not sure how we beat the lpj=
> > > > case, but it did outperform.
> > > >
> > > > One thing to note is the total BogoMIPS value is also consistently higher.
> > > > I am wondering if this is an effect with the cores being in performance
> > > > mode.  I did notice that the parallel calibrate_delay calls did cause the
> > > > fans on the machine to ramp up to full speed where the normal sequential
> > > > calls did not cause them to budge at all.
> > > 
> > > please check attached patch, that could calibrate correctly.
> > > 
> > > Thanks
> > > 
> > > Yinghai
> > 
> > > [PATCH -v2] x86: Make calibrate_delay run in parallel.
> > > 
> > > On a 4096 cpu machine, we noticed that 318 seconds were taken for bringing
> > > up the cpus.  By specifying lpj=<value>, we reduced that to 75 seconds.
> > > Andi Kleen suggested we rework the calibrate_delay calls to run in
> > > parallel.
> > 
> > The risk wit that suggestion is that it will spectacularly miscalibrate on 
> > hyperthreading systems.

I am not trying to be argumentative.  I never got an understanding of
what was going wrong with that earlier patch and am hoping for some
understanding now.

Why does it spectacularly miscalibrate?  Can anything be done to correct
that miscalibration?  Doesn't this patch indicate another problem with
the calibration for hotplug cpus?  Isn't there already a problem if
you boot a cpu normally, then hot-remove a hyperthread of a cpu, run a
userland task which fully loads up all the cores on that socket, then
hot-add that hyperthread back in?  If the lpj value is that volatile,
what value does it really have?

Thank you for your insights,
Robin
