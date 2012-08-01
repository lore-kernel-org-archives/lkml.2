Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab2HALaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 07:30:20 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18831 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab2HALaS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 07:30:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 01 Aug 2012 04:30:01 -0700
Subject: Re: How to use the generic thermal sysfs.
From: Wei Ni <wni@nvidia.com>
To: Zhang Rui <rui.zhang@intel.com>
CC: Jean Delvare <khali@linux-fr.org>, "R, Durgadoss" <durgadoss.r@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "joe@perches.com" <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@ger.kernel.org>,
        Alex Courbot <acourbot@nvidia.com>
In-Reply-To: <1343782972.1682.489.camel@rui.sh.intel.com>
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
	 <1343782972.1682.489.camel@rui.sh.intel.com>
Date: Wed, 1 Aug 2012 19:29:51 +0800
Message-ID: <1343820591.2295.79.camel@tegra-chromium-2>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-01 at 09:02 +0800, Zhang Rui wrote:
> On 五, 2012-07-27 at 18:48 +0800, Wei Ni wrote:
> > On Fri, 2012-07-27 at 15:39 +0800, Zhang Rui wrote:
> > > On 五, 2012-07-27 at 09:30 +0200, Jean Delvare wrote:
> > > > On Fri, 27 Jul 2012 10:58:21 +0800, Wei Ni wrote:
> > > > > On Fri, 2012-07-27 at 09:21 +0800, Zhang Rui wrote:
> > > > > > is it possible to program the sensor at this time, in your own thermal
> > > > > > driver?
> > > > > 
> > > > > Since we are using the generic thermal driver lm90.c, I'm not sure if we
> > > > > could program these limits in the generic driver, I think it's better to
> > > > > have a generic interface to set the limits, so I wish to add a
> > > > > callback .set_limits() in the generic thermal framework.
> > > > 
> > > > I can confirm that hwmon drivers do not set limits, it is up to
> > > > user-space to do it if they want. So if there is a need to do so in the
> > > > kernel itself, a proper interface at the generic thermal framework
> > > > level seems appropriate.
> > > > 
> > > oh, setting limits from userspace?
> > > I think you can program the senor when writing the trip point?
> > > with this patch,
> > > http://marc.info/?l=linux-acpi&m=134318814620429&w=2
> > 
> > Do you mean it can use .set_trip_temp() to set limits when writing the
> > trip point? But I think this callback is used to change the trip_temp,
> > it could not used to set the limits, in here the limit value is used to
> > trigger the interrupt.
> > 
> yes, you are right. .set_trip_temp does not work.
> 
> usually, this is needed to re-program the sensor when the temperature
> hits a trip point , right?

Yes, we need to re-program the sensor to set the limit value.

> 
> can we make use of the thermal_zone_device_ops.notify()?
> say we invoke .notify() in thermal_zone_device_update for each trip
> point.

oh, it's a good idea, we can re-program the sensor in the .notify(), is
it right?
I will try it later, thanks for your suggestions.

> 
> thanks,
> rui


