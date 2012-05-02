Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498Ab2EBFMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 01:12:48 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:43326 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756312Ab2EBFMo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 01:12:44 -0400
MIME-Version: 1.0
In-Reply-To: <87wr4wriq3.fsf@ti.com>
References: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
	<20120426191159.GA9415@sirena.org.uk>
	<CAJ6a13a6WN9h1QZynpEOf-R6RXwWBZ2eOPkTeNc15JX_YfAz_w@mail.gmail.com>
	<20120427175657.GP18260@opensource.wolfsonmicro.com>
	<87397o3n4y.fsf@ti.com>
	<20120430095429.GB3170@opensource.wolfsonmicro.com>
	<87wr4wriq3.fsf@ti.com>
Date: Wed, 2 May 2012 10:34:29 +0530
Message-ID: <CAJ6a13ZBwZn20ObD2hy=xna8oFoKtdczYNxyWACJZoJkhKhsUQ@mail.gmail.com>
Subject: Re: [PATCH V3 00/10] PM: Create the AVS(Adaptive Voltage Scaling)
From: "J, KEERTHY" <j-keerthy@ti.com>
To: Kevin Hilman <khilman@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        rjw@sisk.pl, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, j-pihet@ti.com,
        durgadoss.r@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 1, 2012 at 3:21 AM, Kevin Hilman <khilman@ti.com> wrote:
> Mark Brown <broonie@opensource.wolfsonmicro.com> writes:
>
>> On Fri, Apr 27, 2012 at 02:01:17PM -0700, Kevin Hilman wrote:
>>> Mark Brown <broonie@opensource.wolfsonmicro.com> writes:
>>
>>> > But presumably these things should integrate somehow - for example,
>>> > should devfreq and cpufreq be providing inputs into what AVS is doing,
>>> > and if so how?
>>
>>> The way it is currently designed, cpufreq/devfreq/regulator layers don't
>>> need to know about AVS.
>>
>> Yes, and that was a part of my concern, but see below.
>>
>>> The higher-level layers only know about the "nominal" voltage.  AVS
>>> hardware does automatic, adaptive, micro-adjustments around that nominal
>>> voltage, and these micro-adjustments are managed by the AVS hardware
>>> sending commands to the PMIC.  (specifically, on OMAP, the AVS sensors
>>> provide inputs to the voltage processor (VP) which provide inputs to the
>>> voltage controller (VC) which sends commands to the PMIC[1].)
>>
>> Right, that's what I'd understood it to be.
>>
>>> The driver proposed here is primarily for initializing the various
>>> parameters/sensitivity/etc. of the AVS hardware, but the actual voltage
>>> adjustments are done in hardware by VC/VP.
>>
>> It's not just a driver, though - it's also creating this power/avs
>> thing, though now I look at the code rather than just its shape there's
>> not actually an abstraction being added here, it's mostly just straight
>> code motion of the arch/arm code that's there already.  The changelog
>> and the shape of the code make it sound like this is intended to be
>> somewhat generic when really it's providing some OMAP specific tuning
>> for the device which is much less of a concern.
>>
>> I guess for now it's probably OK to just clarify in the documentation
>> and say that whoever adds the second driver has to work on making this
>> generic :)
>
> Agreed.
>
> In a different thread (which I can't seem to find now) we discussed this
> as well, so it just sounds like the changelog should clarify this a bit
> better.

Kevin/Mark,

Thanks for the feedback. I will add more documentation
to clarify this aspect. Please let me know if there are any more
things to be taken care of in this patch set.

>
> Kevin
>
>> This does also sound rather like it's in a similar area to the current
>> management work which Durgadoss R (CCed) was working on, though with a
>> slightly different application and in the OMAP case it's pretty much all
>> hidden in the external processor.
>



-- 
Regards and Thanks,
Keerthy
