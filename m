Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab1CUTkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 15:40:41 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41148 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697Ab1CUTki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 15:40:38 -0400
Subject: Re: 2.6.39 crashes BUG: unable to handle kernel NULL pointer
 dereference at 000000000000042 .. cmos_checkintr+0x4d/0x55 under Xen as PV
 guest.
From: John Stultz <john.stultz@linaro.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
In-Reply-To: <20110319025134.GA3298@dumpdata.com>
References: <20110318203830.GA9262@dumpdata.com>
	 <1300485566.2731.46.camel@work-vm>  <20110319025134.GA3298@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Mar 2011 12:40:00 -0700
Message-ID: <1300736400.2731.66.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-18 at 22:51 -0400, Konrad Rzeszutek Wilk wrote:
> On Fri, Mar 18, 2011 at 02:59:26PM -0700, John Stultz wrote:
> > On Fri, 2011-03-18 at 16:38 -0400, Konrad Rzeszutek Wilk wrote:
> > > With the latest linus/master I get this when starting a Xen Linux PV
> > > guest:
> > > 
> > > [    0.404760] initcall psmouse_init+0x0/0x79 returned 0 after 59 usecs
> > > [    0.404767] calling  cmos_init+0x0/0x6a @ 1
> > > [    0.464855] BUG: unable to handle kernel NULL pointer dereference at 0000000000000428
> > > [    0.464867] IP: [<ffffffff8105d347>] queue_work_on+0x4/0x1d
> > [snip]
> > > [    0.465018] Call Trace:
> > > [    0.465023]  [<ffffffff8105d38f>] queue_work+0x1a/0x1c
> > > [    0.465029]  [<ffffffff8105d3a4>] schedule_work+0x13/0x15
> > > [    0.465035]  [<ffffffff81331b2e>] rtc_update_irq+0x10/0x12
> > > [    0.465041]  [<ffffffff81333939>] cmos_checkintr+0x4d/0x55
> > > [    0.465047]  [<ffffffff81333987>] cmos_irq_disable+0x46/0x4e
> > > [    0.465051]  [<ffffffff8133481d>] cmos_set_alarm+0xd9/0x16e
> > > [    0.465051]  [<ffffffff813320a4>] __rtc_set_alarm+0x7d/0x88
> > > [    0.465051]  [<ffffffff813321fa>] rtc_timer_enqueue+0x71/0xb8
> > > [    0.465051]  [<ffffffff81331707>] ? rtc_tm_to_time+0x2f/0x38
> > > 
> > > ... full log at the end.
> > > 
> > > From a brief look it looks as if rtc_device_register was never
> > > called, so
> > > 
> > > INIT_WORK(&rtc->irqwork, rtc_timer_do_work);
> > > 
> > > was never called.. and hence schedule_work tries to derefence an
> > > unitialized rtc->irqwork.
> > > 
> > > Which actually sounds right - the rtc_device_register should not
> > > be called since there are no RTC clocks exposed.
> > 
> > 
> > Huh. Did you see this with 2.6.38 vanilla? Just want to clarify if this
> 
> No. 2.6.38 vaniall works great.

Ok. Hrm. 

> > Any insight there?
> 
> I hoped you might have :-)

Could you help me understand where in the probe logic xen bombs out of
the cmos code?

thanks
-john



