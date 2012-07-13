Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab2GMJys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 05:54:48 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16782 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab2GMJyq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 05:54:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 13 Jul 2012 02:54:30 -0700
Subject: RE: How to use the generic thermal sysfs.
From: Wei Ni <wni@nvidia.com>
To: Zhang Rui <rui.zhang@intel.com>
CC: "R, Durgadoss" <durgadoss.r@intel.com>, "Brown, Len" <len.brown@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "joe@perches.com" <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@ger.kernel.org" <linux-tegra@vger.kernel.org>,
        Alex Courbot <acourbot@nvidia.com>
In-Reply-To: <1342167087.27605.158.camel@tegra-chromium-2>
References: <1342088573.27605.101.camel@tegra-chromium-2>
	 <4D68720C2E767A4AA6A8796D42C8EB5915287C@BGSMSX101.gar.corp.intel.com>
	 <1342144273.1682.237.camel@rui.sh.intel.com>
	 <1342164616.27605.129.camel@tegra-chromium-2>
	 <1342165278.1682.259.camel@rui.sh.intel.com>
	 <1342167087.27605.158.camel@tegra-chromium-2>
Date: Fri, 13 Jul 2012 17:53:33 +0800
Message-ID: <1342173213.27605.174.camel@tegra-chromium-2>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-13 at 16:11 +0800, Wei Ni wrote:
> On Fri, 2012-07-13 at 15:41 +0800, Zhang Rui wrote:
> > On 五, 2012-07-13 at 15:30 +0800, Wei Ni wrote:
> > > Our tegra thermal framework also will use the generic thermal layer. It
> > > will register the cooling device, and run the throttling in this generic
> > > framework.
> > > But we have a special mechanism, when the temp is below the trip temp,
> > > we will set different cpu capability for different temp range. For
> > > example, set the low/high temp as 20C/30C to the sensor, and set the cpu
> > > to the max capability, it mean the cpu can run up to the max freq and
> > > voltage in this temp range. if the temp is out that range, the sensor
> > > will have irq/alert to notify the tegra framework, then we will set to
> > > another temperature range and cpu capability.
> > > I think we can try to add this mechanism to the generic framework as a
> > > new policy, right?
> > > 
> > I think you can make use of the upper&lower limit in my patch set.
> > Say, here is your thermal policy
> > 20C - 30C, P0
> > 30C - 40C, P1 - P2
> > 40C - 60C, P3 - P5
> > 60C+, P6 ~ Pn
> > 
> > you can register to the thermal layer 4 passive trip points,
> > 20C, 30C, 40C, 60C, and then
> > 1) for trip 0 (20C), upper limit 0, lower limit 0
> > 2) for trip 1 (30C), upper limit 2, lower limit 1
> > 3) for trip 2 (40C), upper limit 5, lower limit 3
> > 4) for trip 3 (60C), upper limit n, lower limit 6
> > 
> > you can program your own sensor to get interrupt when the temperature
> > hits 20C/30C/40C/60C, and the generic thermal layer will put the
> > processors to proper frequency for each trip point.
> > 
> > what do you think?
> 
> It's great, this is exactly what we need.
> I think for these trip points, we can use a new trip type, such as
> TRIP_LIMIT, and use new policy. Because in these state, we only need to
> set the processors to proper frequency capability, it's not like the
> passive type, the currently passive type will try to set cooling device
> state continually.

I read the patches of "Thermal Framework Enhancements", it seems the
fair_share governor can be used for this throttling.

Look forward to your public git tree, so that I can sync the entire
codes :)

> And for these trip temp, it's better to add hysteresis value, so that it
> can avoid unnecessary interrupt.
> 
> > 
> > BTW, the upper and lower limit is introduced in the patch set I'm
> > testing, so maybe you were not aware of it.
> 
> How can I get these codes?
> 
> > 
> > thanks,
> > rui
> 


