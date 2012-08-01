Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab2HABBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 21:01:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:15240 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815Ab2HABBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 21:01:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="175506674"
Message-ID: <1343782972.1682.489.camel@rui.sh.intel.com>
Subject: Re: How to use the generic thermal sysfs.
From: Zhang Rui <rui.zhang@intel.com>
To: Wei Ni <wni@nvidia.com>
Cc: Jean Delvare <khali@linux-fr.org>, "R, Durgadoss" <durgadoss.r@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "joe@perches.com" <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@ger.kernel.org" <linux-tegra@ger.kernel.org>,
        Alex Courbot <acourbot@nvidia.com>
Date: Wed, 01 Aug 2012 09:02:52 +0800
In-Reply-To: <1343386122.4042.88.camel@tegra-chromium-2>
References: <1342088573.27605.101.camel@tegra-chromium-2>
	 <4D68720C2E767A4AA6A8796D42C8EB5915287C@BGSMSX101.gar.corp.intel.com>
	 <1342144273.1682.237.camel@rui.sh.intel.com>
	 <1342164616.27605.129.camel@tegra-chromium-2>
	 <1342165278.1682.259.camel@rui.sh.intel.com>
	 <1343295094.4042.24.camel@tegra-chromium-2>
	 <1343352098.1682.447.camel@rui.sh.intel.com>
	 <1343357901.4042.70.camel@tegra-chromium-2>
	 <20120727093037.094335eb@endymion.delvare>
	 <1343374793.1682.475.camel@rui.sh.intel.com>
	 <1343386122.4042.88.camel@tegra-chromium-2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 五, 2012-07-27 at 18:48 +0800, Wei Ni wrote:
> On Fri, 2012-07-27 at 15:39 +0800, Zhang Rui wrote:
> > On 五, 2012-07-27 at 09:30 +0200, Jean Delvare wrote:
> > > On Fri, 27 Jul 2012 10:58:21 +0800, Wei Ni wrote:
> > > > On Fri, 2012-07-27 at 09:21 +0800, Zhang Rui wrote:
> > > > > is it possible to program the sensor at this time, in your own thermal
> > > > > driver?
> > > > 
> > > > Since we are using the generic thermal driver lm90.c, I'm not sure if we
> > > > could program these limits in the generic driver, I think it's better to
> > > > have a generic interface to set the limits, so I wish to add a
> > > > callback .set_limits() in the generic thermal framework.
> > > 
> > > I can confirm that hwmon drivers do not set limits, it is up to
> > > user-space to do it if they want. So if there is a need to do so in the
> > > kernel itself, a proper interface at the generic thermal framework
> > > level seems appropriate.
> > > 
> > oh, setting limits from userspace?
> > I think you can program the senor when writing the trip point?
> > with this patch,
> > http://marc.info/?l=linux-acpi&m=134318814620429&w=2
> 
> Do you mean it can use .set_trip_temp() to set limits when writing the
> trip point? But I think this callback is used to change the trip_temp,
> it could not used to set the limits, in here the limit value is used to
> trigger the interrupt.
> 
yes, you are right. .set_trip_temp does not work.

usually, this is needed to re-program the sensor when the temperature
hits a trip point , right?

can we make use of the thermal_zone_device_ops.notify()?
say we invoke .notify() in thermal_zone_device_update for each trip
point.

thanks,
rui
> > 
> > thanks,
> > rui
> > 
> > 
> 
> 


