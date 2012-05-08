Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234Ab2EHDsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 23:48:51 -0400
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:39956 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757751Ab2EHDst convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 23:48:49 -0400
MIME-Version: 1.0
In-Reply-To: <87mx5jy2li.fsf@ti.com>
References: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
	<20120426191159.GA9415@sirena.org.uk>
	<CAJ6a13a6WN9h1QZynpEOf-R6RXwWBZ2eOPkTeNc15JX_YfAz_w@mail.gmail.com>
	<20120427175657.GP18260@opensource.wolfsonmicro.com>
	<87397o3n4y.fsf@ti.com>
	<331ABD5ECB02734CA317220B2BBEABC13E9B1A67@DBDE01.ent.ti.com>
	<87mx5jy2li.fsf@ti.com>
Date: Tue, 8 May 2012 09:18:48 +0530
Message-ID: <CAJ6a13arx4bNzc1ByXj=E9gwE3hrw7muZUwmbo3doYAzK-pAnQ@mail.gmail.com>
Subject: Re: [PATCH V3 00/10] PM: Create the AVS(Adaptive Voltage Scaling)
From: "J, KEERTHY" <j-keerthy@ti.com>
To: Kevin Hilman <khilman@ti.com>, "AnilKumar, Chimata" <anilkumar@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "Pihet-XID, Jean" <j-pihet@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 8, 2012 at 5:18 AM, Kevin Hilman <khilman@ti.com> wrote:
> "AnilKumar, Chimata" <anilkumar@ti.com> writes:
>
>> On Sat, Apr 28, 2012 at 02:31:17, Hilman, Kevin wrote:
>>> Hi Mark,
>>>
>>> Mark Brown <broonie@opensource.wolfsonmicro.com> writes:
>>>
>>> > On Fri, Apr 27, 2012 at 11:09:10AM +0530, J, KEERTHY wrote:
>>> >
>>> >> Devfreq and cpufreq are related to dynamic frequency/voltage switching between
>>> >> pre defined Operating Performance Points or the OPPs. Every OPP being
>>> >> a voltage/frequency pair. Smartreflex is a different
>>> >> power management technique.
>>> >
>>> > But presumably these things should integrate somehow - for example,
>>> > should devfreq and cpufreq be providing inputs into what AVS is doing,
>>> > and if so how?
>>>
>>> The way it is currently designed, cpufreq/devfreq/regulator layers don't
>>> need to know about AVS.
>>>
>>> The higher-level layers only know about the "nominal" voltage.  AVS
>>> hardware does automatic, adaptive, micro-adjustments around that nominal
>>> voltage, and these micro-adjustments are managed by the AVS hardware
>>> sending commands to the PMIC.  (specifically, on OMAP, the AVS sensors
>>> provide inputs to the voltage processor (VP) which provide inputs to the
>>> voltage controller (VC) which sends commands to the PMIC[1].)
>>>
>>> The driver proposed here is primarily for initializing the various
>>> parameters/sensitivity/etc. of the AVS hardware, but the actual voltage
>>> adjustments are done in hardware by VC/VP.
>>>
>>> The only thing the higher-level layers might potentially need to do to
>>> enable/disable AVS around transitions (e.g. when changing OPP, AVS is
>>> disabled before changing OPP and only re-enabled when the new nominal
>>> voltage has been acheived.)
>>>
>>> On OMAP, we handle this inside the OMAP-specific voltage layer which is
>>> called by the regulator framework, so even the regulators do not need
>>> any knowledge of AVS.
>>
>> Kevin,
>>
>> I want to point out some cases of SR implementation where this may not
>> be true.
>>
>> Devices like DM8168, DM8148 and AM335X use Class 2B implementation of SR.
>>
>> Under this, SR module issues an interrupt to ARM when there is a need to
>> change the voltage based on temperature changes, ageing etc.
>>
>> Once the interrupt arrives, kernel needs to adjust voltage using regulator API.
>> The voltage change is a micro adjustment as in other SR classes.
>
> That can easily be handled writing a plugin specific to class 2B.  This
> driver was designed so plugins for other classes can be supported.
>
> Sure, we might need some enhancements for other classes (we already know
> that we will for class 1 support.)  However, the purpose of this series
> is to do the cleanups necessary for the driver to move to drivers/*.

AnilKumar,

The intent of the series as explained by Kevin if to do the necessary clean up
for the driver to move from mach-omap to drivers/*. We will for sure need
more enhancements for other classes support.

>
> Support for additional classes can be added after the driver is moved
> if/when folks are motivated to post that support upstream.
>
>> The SR class 2B implementation on these devices does not exist in mainline.
>> I can point to some public repositories if you are interested in taking a look at
>> the current code.
>
> No thanks.  We can discuss it when you post support for it to mainline.
>
> Kevin
>
>> Implementation of this SR method is must on at least the DM8168 device and
>> I know some customers who are using it on their production systems.
>>
>> Regards
>> AnilKumar
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Regards and Thanks,
Keerthy
