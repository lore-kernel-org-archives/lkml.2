Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab0DLSuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 14:50:37 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:42248 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab0DLSug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 14:50:36 -0400
Subject: Re: re-adding clocksource_get_next ?
From: john stultz <johnstul@us.ibm.com>
To: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4BC2B770.3020501@st.com>
References: <4BBECED7.4010004@st.com>
	 <x2p1f1b08da1004091358z1d185aacya6c0fa2f55322fc7@mail.gmail.com>
	 <4BC2B770.3020501@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Apr 2010 11:50:18 -0700
Message-ID: <1271098218.3724.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-12 at 08:02 +0200, Giuseppe CAVALLARO wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hello John,
> 
> john stultz wrote:
> > On Thu, Apr 8, 2010 at 11:53 PM, Giuseppe CAVALLARO
> > <peppe.cavallaro@st.com> wrote:
> >> Hello!
> >> this function was removed in the past but I've not clear all the details.
> >> While testing LLTng, I wrote the patch, in attachment, that re-adds it
> >> again.
> >> The clocksource_get_next returns the first clock source available
> >> (without looking at the rating).
> >> In my environment, a clock source is a TMU channel (e.g. TMU1) and,
> >> indeed, clocksource_get_next works fine.
> > 
> > Could you provide some more details as to why you need raw access to
> > the clocksource, instead of using something like ktime_get(),
> > getrawmonotonic() or sched_clock()?
> 
> I wanted to directly read the value of the TCNT register of a TMU
> channel registered as clocksource in an SH platform.
> My idea was to get the first clocksource available and than use the read
> hook to get its raw value.
> Indeed, on SH4, the clocksource_get_next returns the TMU channel 1
> (usually registered as clocksource); the clk->reads points to
> sh_tmu_clocksource_read (drivers/clocksource/sh_tmu.c). This returns the
> value of the timer count register (TCNT).

If you specifically want the function sh_tmu_clocksource_read(), why not
call it directly instead of indirecting through the clocksource
infrastructure?

Additionally, since the clocksource code is dynamic, you might get a
different clocksource then you expect (such as jiffies) depending on
user config or user actions.

So I'd advise against using the clocksource code here.

thanks
-john




