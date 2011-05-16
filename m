Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364Ab1EPQdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 12:33:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:47372 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab1EPQdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 12:33:18 -0400
Date: Mon, 16 May 2011 18:33:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Colin Cross <ccross@android.com>
cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Rickard ANDERSSON <rickard.andersson@stericsson.com>,
        Varun Swara <Varun.Swara@arm.com>,
        martin persson <martin.persson@stericsson.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: twd: Adjust localtimer frequency
 withcpufreqnotifiers
In-Reply-To: <BANLkTimMSPmqD+kyz1EJUrH9sS=qWRZymw@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1105161831440.3078@ionos>
References: <1290060899-9786-1-git-send-email-ccross@android.com> <AANLkTimCuV5N0jr8c949uONEvieQ5MDZ9KHDXtneG5AT@mail.gmail.com> <4D70BE9D.4000507@stericsson.com> <AANLkTin7ZXYALOy_jk1uR3SbZA51nSnU-ncSjG+n_RPn@mail.gmail.com> <4D714C17.7080102@gmail.com>
 <AANLkTims4e7o0sPxVnN0D1mNWDH7uC9q=pBQrBoad2os@mail.gmail.com> <eea425c066cc69c30f118fb102fff43e@mail.gmail.com> <AANLkTi=KcmqmghVxhwGvv79heRU3C+TC-v2VnWSWt7bU@mail.gmail.com> <7e9fafa016bfe536ccc373fc2cc7ba61@mail.gmail.com>
 <AANLkTinRNG4nTjh15a2tuJt_iDboHUtomxemSjY+6DcD@mail.gmail.com> <AANLkTikkcYw66MiJO9Bpm+De=XD2-1MFxm-CUPp6sMqL@mail.gmail.com> <BANLkTi=-T6P0KrsQ8+Ot_inq1JabY62LvA@mail.gmail.com> <alpine.LFD.2.02.1105131138460.2831@ionos> <BANLkTimxkY4MvQ+-qiOwdwbo7jPUAQ1vxw@mail.gmail.com>
 <alpine.LFD.2.02.1105141749510.3078@ionos> <4DD10814.1010103@ti.com> <alpine.LFD.2.02.1105161642250.3078@ionos> <BANLkTimMSPmqD+kyz1EJUrH9sS=qWRZymw@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 May 2011, Colin Cross wrote:
> On Mon, May 16, 2011 at 7:44 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Mon, 16 May 2011, Santosh Shilimkar wrote:
> >> On 5/14/2011 9:21 PM, Thomas Gleixner wrote:
> >> Just for my understanding, the clockevents_reconfigure() needs to
> >> be called with interrupts disabled on that CPU as part of
> >> the CPUFREQ notifiers. I assume the right place is do it
> >> in POST notifier after the CPU clock and hence TWD clock is
> >> updated. Is that right ?
> >
> > Yes.
> 
> Is it safe to only call it in POST?  If the frequency is increasing,
> and the TWD is not updated until after the CPU frequency has changed,
> it is possible for a clockevent to fire too early.  Will that cause
> problems, or does the clockevent code check against a clocksource to
> ensure the desired time has been reached?  If that is OK, it
> drastically simplifies the code, because the driver only needs to know
> the current TWD frequency, not predict a future TWD frequency.

Yes, the hrtimer code checks against current time, so if it fires too
early it rearms the timer.
 
Thanks,

	tglx
