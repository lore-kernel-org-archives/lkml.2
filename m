Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab1DFGmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 02:42:20 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:60121 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751978Ab1DFGmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 02:42:18 -0400
Message-ID: <4D9C0B34.3080909@ti.com>
Date: Wed, 06 Apr 2011 12:11:56 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: david@lang.hm, Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@fluxnic.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        linux-arm-kernel@lists.infradead.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Detlef Vollmann <dv@vollmann.ch>,
        David Brown <davidb@codeaurora.org>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home>	<201104031726.37420.arnd@arndb.de>	<20110403160324.GA8050@n2100.arm.linux.org.uk>	<201104040259.26601.arnd@arndb.de>	<1301915022.15819.28.camel@e102109-lin.cambridge.arm.com>	<20110404112104.GB19854@n2100.arm.linux.org.uk>	<1301923457.417.34.camel@e102391-lin.cambridge.arm.com>	<20110404133104.GA23266@n2100.arm.linux.org.uk>	<1301925445.417.54.camel@e102391-lin.cambridge.arm.com>	<BANLkTi=d-rQpinSW9YPsZbkh9tDK5FLS+w@mail.gmail.com>	<4D9AB958.5010304@ti.com> <BANLkTins_YaNYSRc1ryZuRSnGKO2MEemuA@mail.gmail.com>
In-Reply-To: <BANLkTins_YaNYSRc1ryZuRSnGKO2MEemuA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/6/2011 3:52 AM, Linus Walleij wrote:
> 2011/4/5 Santosh Shilimkar<santosh.shilimkar@ti.com>:
>
>> The only issue I see is the clock-events implemented using
>> local timers capabilities in low power modes. The local timers
>> won't be able wakeup CPU from DORMANT or OFF state and hence
>> you will need an additional wakeup capable clock-event
>> working together with the local timers using clock-notifiers.
>
> And this is because the IRQs it emits are local and thus cannot wake
> the system? This sounds way backwards... A simple naïve solution
> would have been to just route out an external IRQ line back from a
> selected timer and into the GIC so it will be able to wake up the
> system, right?
>
Even the GIC would be dead is certain low power modes. It's need
GIC extension to route these signals and seems that it's bit
tricky hardware implementation since the timer logic
needs to be moved to ALWAYS ON power domain.

Regards
Santosh
