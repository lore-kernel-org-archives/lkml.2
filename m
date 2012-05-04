Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab2EDIVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 04:21:47 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39959 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771Ab2EDIVo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 04:21:44 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: "Hilman, Kevin" <khilman@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "J, KEERTHY" <j-keerthy@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "Pihet-XID, Jean" <j-pihet@ti.com>
Subject: RE: [PATCH V3 00/10] PM: Create the AVS(Adaptive Voltage Scaling)
Thread-Topic: [PATCH V3 00/10] PM: Create the AVS(Adaptive Voltage Scaling)
Thread-Index: AQHNJLjjs1uxvoFzMEiL01IQh+b9kZa5L8zw
Date: Fri, 4 May 2012 08:21:28 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13E9B1A67@DBDE01.ent.ti.com>
References: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
	<20120426191159.GA9415@sirena.org.uk>
	<CAJ6a13a6WN9h1QZynpEOf-R6RXwWBZ2eOPkTeNc15JX_YfAz_w@mail.gmail.com>
	<20120427175657.GP18260@opensource.wolfsonmicro.com> <87397o3n4y.fsf@ti.com>
In-Reply-To: <87397o3n4y.fsf@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.132.210]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2012 at 02:31:17, Hilman, Kevin wrote:
> Hi Mark,
> 
> Mark Brown <broonie@opensource.wolfsonmicro.com> writes:
> 
> > On Fri, Apr 27, 2012 at 11:09:10AM +0530, J, KEERTHY wrote:
> >
> >> Devfreq and cpufreq are related to dynamic frequency/voltage switching between
> >> pre defined Operating Performance Points or the OPPs. Every OPP being
> >> a voltage/frequency pair. Smartreflex is a different
> >> power management technique.
> >
> > But presumably these things should integrate somehow - for example,
> > should devfreq and cpufreq be providing inputs into what AVS is doing,
> > and if so how?
> 
> The way it is currently designed, cpufreq/devfreq/regulator layers don't
> need to know about AVS.
> 
> The higher-level layers only know about the "nominal" voltage.  AVS
> hardware does automatic, adaptive, micro-adjustments around that nominal
> voltage, and these micro-adjustments are managed by the AVS hardware
> sending commands to the PMIC.  (specifically, on OMAP, the AVS sensors
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

Kevin,

I want to point out some cases of SR implementation where this may not
be true.

Devices like DM8168, DM8148 and AM335X use Class 2B implementation of SR.

Under this, SR module issues an interrupt to ARM when there is a need to
change the voltage based on temperature changes, ageing etc.

Once the interrupt arrives, kernel needs to adjust voltage using regulator API.
The voltage change is a micro adjustment as in other SR classes.

The SR class 2B implementation on these devices does not exist in mainline.
I can point to some public repositories if you are interested in taking a look at
the current code.

Implementation of this SR method is must on at least the DM8168 device and
I know some customers who are using it on their production systems.

Regards
AnilKumar
