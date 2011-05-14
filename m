Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282Ab1ENPvf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 11:51:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:54402 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757560Ab1ENPvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 11:51:32 -0400
Date: Sat, 14 May 2011 17:51:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Colin Cross <ccross@android.com>
cc: Linus Walleij <linus.walleij@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
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
In-Reply-To: <BANLkTimxkY4MvQ+-qiOwdwbo7jPUAQ1vxw@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1105141749510.3078@ionos>
References: <1290060899-9786-1-git-send-email-ccross@android.com> <AANLkTimCuV5N0jr8c949uONEvieQ5MDZ9KHDXtneG5AT@mail.gmail.com> <4D70BE9D.4000507@stericsson.com> <AANLkTin7ZXYALOy_jk1uR3SbZA51nSnU-ncSjG+n_RPn@mail.gmail.com> <4D714C17.7080102@gmail.com>
 <AANLkTims4e7o0sPxVnN0D1mNWDH7uC9q=pBQrBoad2os@mail.gmail.com> <eea425c066cc69c30f118fb102fff43e@mail.gmail.com> <AANLkTi=KcmqmghVxhwGvv79heRU3C+TC-v2VnWSWt7bU@mail.gmail.com> <7e9fafa016bfe536ccc373fc2cc7ba61@mail.gmail.com>
 <AANLkTinRNG4nTjh15a2tuJt_iDboHUtomxemSjY+6DcD@mail.gmail.com> <AANLkTikkcYw66MiJO9Bpm+De=XD2-1MFxm-CUPp6sMqL@mail.gmail.com> <BANLkTi=-T6P0KrsQ8+Ot_inq1JabY62LvA@mail.gmail.com> <alpine.LFD.2.02.1105131138460.2831@ionos>
 <BANLkTimxkY4MvQ+-qiOwdwbo7jPUAQ1vxw@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2023042285-1305388282=:3078"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2023042285-1305388282=:3078
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 13 May 2011, Colin Cross wrote:
> On Fri, May 13, 2011 at 3:02 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >  /**
> > + * clockevents_reconfigure - Reconfigure and reprogram a clock event device.
> > + * @dev:       device to modify
> > + * @freq:      new device frequency
> > + * @secr:      guaranteed runtime conversion range in seconds
> > + *
> > + * Reconfigure and reprogram a clock event device in oneshot
> > + * mode. Must only be called from low level idle code where
> > + * interaction with hrtimers/nohz code etc. is not possible and
> > + * guaranteed not to conflict. Must be called with interrupts
> > + * disabled!
> > + * Returns 0 on success, -ETIME when the event is in the past or
> > + * -EINVAL when called with invalid parameters.
> > + */
> We need to call this from a cpufreq notifier with interrupts disabled,
> not from idle.

That works as well. Comments needs update. The important thing is that
neither a timer interrupt nor a hrtimer function should interfere on
that very cpu.

Thanks,

	tglx

--8323328-2023042285-1305388282=:3078--
