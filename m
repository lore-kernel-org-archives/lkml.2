Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab0EGPpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 11:45:15 -0400
Received: from www.tglx.de ([62.245.132.106]:46503 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756714Ab0EGPpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 11:45:13 -0400
Date: Fri, 7 May 2010 17:44:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <johnstul@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add clocksource_register_hz/khz interface
In-Reply-To: <1273112824-5112-1-git-send-email-johnstul@us.ibm.com>
Message-ID: <alpine.LFD.2.00.1005071735260.3401@localhost.localdomain>
References: <1273112824-5112-1-git-send-email-johnstul@us.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 May 2010, John Stultz wrote:

> Hey Thomas,
> 	I updated the patch docs and made the calls EXPORT_SYMBOL_GPL.
> However the need for both khz and hz is due to high freq clocksources
> like the TSC who's cycles/sec are close to the upper bound of a u32.

Come on. It's not that hard :)

int clocksource_register_freq(struct clocksource *cs, u32 scale, u32 freq)
{
	clocks_calc_mult_shift(&cs->mult, &cs->shift, freq,
			       NSEC_PER_SEC / scale, MAX_UPDATE_LENGTH * scale);

	....
}

static inline int clocksource_register_hz(struct clocksource *cs, u32 freq)
{
	clocksource_regiser_freq(cs, 1, freq);
}

static inline int clocksource_register_khz(struct clocksource *cs, u32 freq)
{
	clocksource_regiser_freq(cs, 1000, freq);
}
 
Thanks,

	tglx
