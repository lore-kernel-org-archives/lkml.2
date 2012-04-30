Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab2D3Ea7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 00:30:59 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:53633 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751205Ab2D3Ea6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 00:30:58 -0400
MIME-Version: 1.0
In-Reply-To: <87397o3n4y.fsf@ti.com>
References: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
	<20120426191159.GA9415@sirena.org.uk>
	<CAJ6a13a6WN9h1QZynpEOf-R6RXwWBZ2eOPkTeNc15JX_YfAz_w@mail.gmail.com>
	<20120427175657.GP18260@opensource.wolfsonmicro.com>
	<87397o3n4y.fsf@ti.com>
Date: Mon, 30 Apr 2012 09:55:26 +0530
Message-ID: <CAJ6a13ZFj47nps1teNHyE3FyzZOUBx9HDOL-3_CNC+_vdbs6ag@mail.gmail.com>
Subject: Re: [PATCH V3 00/10] PM: Create the AVS(Adaptive Voltage Scaling)
From: "J, KEERTHY" <j-keerthy@ti.com>
To: Kevin Hilman <khilman@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        rjw@sisk.pl, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, j-pihet@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2012 at 2:31 AM, Kevin Hilman <khilman@ti.com> wrote:
> Hi Mark,
>
> Mark Brown <broonie@opensource.wolfsonmicro.com> writes:
>
>> On Fri, Apr 27, 2012 at 11:09:10AM +0530, J, KEERTHY wrote:
>>
>>> Devfreq and cpufreq are related to dynamic frequency/voltage switching between
>>> pre defined Operating Performance Points or the OPPs. Every OPP being
>>> a voltage/frequency pair. Smartreflex is a different
>>> power management technique.
>>
>> But presumably these things should integrate somehow - for example,
>> should devfreq and cpufreq be providing inputs into what AVS is doing,
>> and if so how?
>
> The way it is currently designed, cpufreq/devfreq/regulator layers don't
> need to know about AVS.
>
> The higher-level layers only know about the "nominal" voltage.  AVS
> hardware does automatic, adaptive, micro-adjustments around that nominal
> voltage, and these micro-adjustments are managed by the AVS hardware
> sending commands to the PMIC.  (specifically, on OMAP, the AVS sensors
> provide inputs to the voltage processor (VP) which provide inputs to the
> voltage controller (VC) which sends commands to the PMIC[1].)
>
> The driver proposed here is primarily for initializing the various
> parameters/sensitivity/etc. of the AVS hardware, but the actual voltage
> adjustments are done in hardware by VC/VP.
>
> The only thing the higher-level layers might potentially need to do to
> enable/disable AVS around transitions (e.g. when changing OPP, AVS is
> disabled before changing OPP and only re-enabled when the new nominal
> voltage has been acheived.)
>
> On OMAP, we handle this inside the OMAP-specific voltage layer which is
> called by the regulator framework, so even the regulators do not need
> any knowledge of AVS.
>
> Kevin
>
> [1] Figure 3-76 in OMAP4430 ES2.1 Public TRM vAD provides a
>    detailed diagram:
>    http://www.ti.com/pdfs/wtbu/OMAP4430_ES2.x_PUBLIC_TRM_vAD.zip

Thanks for the detailed answer Kevin.

-- 
Regards and Thanks,
Keerthy
