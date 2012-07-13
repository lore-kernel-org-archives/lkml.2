Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030869Ab2GMSal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 14:30:41 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:49768 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab2GMSaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 14:30:39 -0400
Message-ID: <50006934.1020809@linaro.org>
Date: Fri, 13 Jul 2012 11:30:12 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Mike Turquette <mike.turquette@linaro.org>,
        Marc Zyngier <maz@misterjones.org>
Subject: Re: [PATCH 33/36] AArch64: Generic timers support
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <62038bf130381e2b55cedec5f3c44760@localhost> <4FFF0BE9.2010307@linaro.org> <201207131240.03903.arnd@arndb.de> <20120713160233.GB5544@arm.com>
In-Reply-To: <20120713160233.GB5544@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071318-2398-0000-0000-0000087B6481
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2012 09:02 AM, Catalin Marinas wrote:
> On Fri, Jul 13, 2012 at 01:40:03PM +0100, Arnd Bergmann wrote:
>> Hmm, in the quest to eliminate CLOCK_TICK_RATE entirely, could we
>> make a Kconfig symbol that is selected for all architectures that
>> (may) rely on a periodic timer tick and require this to be set?
>>
>> Architectures that always have a working clock source would then just
>> not include the timex.h header and #define ACT_HZ HZ in common code.
>
> Would something like below be enough?

Looks interesting. Although I've not had a chance to follow through in 
more detail to see what that might impact.  But something like this 
seems like a good approach.


> Also, are there any implications if we boot with clocksource=jiffies?

You'd probably see an maximum error of:
	 (tick-device-granularity/2)/(1sec/HZ).

If that ends up larger then 100ppm you'd have a fairly poor clock, 
although NTP can correct for up to 500ppm.

thanks
-john

