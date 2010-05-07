Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715Ab0EGSuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:50:00 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:41841 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab0EGSt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:49:58 -0400
Subject: Re: [PATCH] Add clocksource_register_hz/khz interface
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1005071735260.3401@localhost.localdomain>
References: <1273112824-5112-1-git-send-email-johnstul@us.ibm.com>
	 <alpine.LFD.2.00.1005071735260.3401@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 May 2010 11:49:38 -0700
Message-ID: <1273258178.2776.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 17:44 +0200, Thomas Gleixner wrote:
> On Wed, 5 May 2010, John Stultz wrote:
> 
> > Hey Thomas,
> > 	I updated the patch docs and made the calls EXPORT_SYMBOL_GPL.
> > However the need for both khz and hz is due to high freq clocksources
> > like the TSC who's cycles/sec are close to the upper bound of a u32.
> 
> Come on. It's not that hard :)

Oh... So your fine with having two interfaces, but just want the code
redundancy removed between the two interfaces? 

Ok, I misunderstood. That's no problem.

thanks
-john


> int clocksource_register_freq(struct clocksource *cs, u32 scale, u32 freq)
> {
> 	clocks_calc_mult_shift(&cs->mult, &cs->shift, freq,
> 			       NSEC_PER_SEC / scale, MAX_UPDATE_LENGTH * scale);
> 
> 	....
> }
> 
> static inline int clocksource_register_hz(struct clocksource *cs, u32 freq)
> {
> 	clocksource_regiser_freq(cs, 1, freq);
> }
> 
> static inline int clocksource_register_khz(struct clocksource *cs, u32 freq)
> {
> 	clocksource_regiser_freq(cs, 1000, freq);
> }
> 
> Thanks,
> 
> 	tglx


