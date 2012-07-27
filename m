Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab2G0BUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 21:20:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:19799 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab2G0BUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 21:20:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="198707716"
Message-ID: <1343352098.1682.447.camel@rui.sh.intel.com>
Subject: RE: How to use the generic thermal sysfs.
From: Zhang Rui <rui.zhang@intel.com>
To: Wei Ni <wni@nvidia.com>
Cc: "R, Durgadoss" <durgadoss.r@intel.com>, "Brown, Len" <len.brown@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "joe@perches.com" <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@ger.kernel.org" <linux-tegra@ger.kernel.org>,
        Alex Courbot <acourbot@nvidia.com>
Date: Fri, 27 Jul 2012 09:21:38 +0800
In-Reply-To: <1343295094.4042.24.camel@tegra-chromium-2>
References: <1342088573.27605.101.camel@tegra-chromium-2>
	 <4D68720C2E767A4AA6A8796D42C8EB5915287C@BGSMSX101.gar.corp.intel.com>
	 <1342144273.1682.237.camel@rui.sh.intel.com>
	 <1342164616.27605.129.camel@tegra-chromium-2>
	 <1342165278.1682.259.camel@rui.sh.intel.com>
	 <1343295094.4042.24.camel@tegra-chromium-2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 四, 2012-07-26 at 17:31 +0800, Wei Ni wrote:
> On Fri, 2012-07-13 at 15:41 +0800, Zhang Rui wrote:
> > On 五, 2012-07-13 at 15:30 +0800, Wei Ni wrote:
> > > 
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
> Hi, Rui
> I'm trying your upper/lower codes on our tegra platform.
> Since we want to set limit value to the sensor to get interrupt, and
> many sensor drivers can support the limit alert property, could we add a
> new callback .set_limits() for the thermal zone device, so that we can
> program it in the generic layer. when the temperature hits the
> trip_temp,

at this time, there should be an interrupt, right?

>  we can try to set to the next limit range.

is it possible to program the sensor at this time, in your own thermal
driver?

thanks,
rui
> I can try to add these codes base on your patches.
> 
> Thanks.
> Wei.
> 
> > 
> > BTW, the upper and lower limit is introduced in the patch set I'm
> > testing, so maybe you were not aware of it.
> > 
> > thanks,
> > rui
> 
> 
> 


