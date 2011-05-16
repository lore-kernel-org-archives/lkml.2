Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab1EPOoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 10:44:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:46505 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab1EPOoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 10:44:14 -0400
Date: Mon, 16 May 2011 16:44:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
cc: Colin Cross <ccross@android.com>, Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        linux-kernel@vger.kernel.org,
        Rickard ANDERSSON <rickard.andersson@stericsson.com>,
        martin persson <martin.persson@stericsson.com>,
        Varun Swara <Varun.Swara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: twd: Adjust localtimer frequency
 withcpufreqnotifiers
In-Reply-To: <4DD10814.1010103@ti.com>
Message-ID: <alpine.LFD.2.02.1105161642250.3078@ionos>
References: <1290060899-9786-1-git-send-email-ccross@android.com> <AANLkTimCuV5N0jr8c949uONEvieQ5MDZ9KHDXtneG5AT@mail.gmail.com> <4D70BE9D.4000507@stericsson.com> <AANLkTin7ZXYALOy_jk1uR3SbZA51nSnU-ncSjG+n_RPn@mail.gmail.com> <4D714C17.7080102@gmail.com>
 <AANLkTims4e7o0sPxVnN0D1mNWDH7uC9q=pBQrBoad2os@mail.gmail.com> <eea425c066cc69c30f118fb102fff43e@mail.gmail.com> <AANLkTi=KcmqmghVxhwGvv79heRU3C+TC-v2VnWSWt7bU@mail.gmail.com> <7e9fafa016bfe536ccc373fc2cc7ba61@mail.gmail.com>
 <AANLkTinRNG4nTjh15a2tuJt_iDboHUtomxemSjY+6DcD@mail.gmail.com> <AANLkTikkcYw66MiJO9Bpm+De=XD2-1MFxm-CUPp6sMqL@mail.gmail.com> <BANLkTi=-T6P0KrsQ8+Ot_inq1JabY62LvA@mail.gmail.com> <alpine.LFD.2.02.1105131138460.2831@ionos> <BANLkTimxkY4MvQ+-qiOwdwbo7jPUAQ1vxw@mail.gmail.com>
 <alpine.LFD.2.02.1105141749510.3078@ionos> <4DD10814.1010103@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 May 2011, Santosh Shilimkar wrote:
> On 5/14/2011 9:21 PM, Thomas Gleixner wrote:
> Just for my understanding, the clockevents_reconfigure() needs to
> be called with interrupts disabled on that CPU as part of
> the CPUFREQ notifiers. I assume the right place is do it
> in POST notifier after the CPU clock and hence TWD clock is
> updated. Is that right ?

Yes.
 
> Since there is need to call this API in interrupt
> disable context, does it make sense to take care of it
> inside the API itself instead of relying on caller fn ?

Hmm, no strong opinion
 
> The arch's where the per CPU TWD's share clock, per-cpu
> clock-events should be reconfigured on all CPUs, whenever
> the parent(CPU) clock has changed using some thing like
> smp_call_function_any() etc. Is that right understanding?

Yes. If that's a common requirement we should move that to core code.
 
Thanks,

	tglx
