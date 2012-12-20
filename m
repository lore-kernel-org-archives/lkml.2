Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579Ab2LTQZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 11:25:44 -0500
Received: from mga11.intel.com ([192.55.52.93]:41868 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063Ab2LTQZi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 11:25:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,324,1355126400"; 
   d="scan'208";a="265083333"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "Zhang, Rui" <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hongbo.zhang@linaro.org" <hongbo.zhang@linaro.org>,
        "wni@nvidia.com" <wni@nvidia.com>
Subject: RE: [PATCH 4/8] Thermal: Add Thermal_trip sysfs node
Thread-Topic: [PATCH 4/8] Thermal: Add Thermal_trip sysfs node
Thread-Index: AQHN3QLhVtjs0vDJ0k+q6f3rVEfUDJgg0z6AgAB+x2CAADE/AIAAX08A
Date: Thu, 20 Dec 2012 16:25:32 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB5924CF1F@BGSMSX101.gar.corp.intel.com>
References: <1355822977-4804-1-git-send-email-durgadoss.r@intel.com>
 <1355822977-4804-5-git-send-email-durgadoss.r@intel.com>
 <20121220054201.GE28007@kroah.com>
 <4D68720C2E767A4AA6A8796D42C8EB5924CB6C@BGSMSX101.gar.corp.intel.com>
 <20121220161202.GA29796@kroah.com>
In-Reply-To: <20121220161202.GA29796@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, December 20, 2012 9:42 PM
> To: R, Durgadoss
> Cc: Zhang, Rui; linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org;
> hongbo.zhang@linaro.org; wni@nvidia.com
> Subject: Re: [PATCH 4/8] Thermal: Add Thermal_trip sysfs node
> 
> On Thu, Dec 20, 2012 at 07:52:03AM +0000, R, Durgadoss wrote:
> > > On Tue, Dec 18, 2012 at 02:59:33PM +0530, Durgadoss R wrote:
> > > > This patch adds a thermal_trip directory under
> > > > /sys/class/thermal/zoneX. This directory contains
> > > > the trip point values for sensors bound to this
> > > > zone.
> > >
> > > Eeek, you just broke userspace tools that now can no longer see these
> > > entries :(
> > >
> > > Why do you need to create a subdirectory?  As you found out, doing so
> > > isn't the easiest, right?  That is on purpose.
> >
> > Yes, I observed the complexity.
> >
> > >
> > > I really wouldn't recommend doing this at all, please stick within the
> > > 'struct device' framework here, don't create new kobjects and hang sysfs
> > > files off of them.
> >
> > But, we cannot put all _trip directly under ZoneX directory.
> 
> Why not?  What is preventing this?
> 
> > We can remove the thermal_trip directory, and put sensorY_trip under
> > /sys/class/thermal/zoneX/.  But this sensorY_trip needs to be a
> > directory which has four sysfs nodes named, active, passive, crit,
> > hot.
> >
> > Rui, What do you think about this ?
> >
> > The only other way I see, is directly put
> sensorY_trip_[active/passive/hot/crit]
> > which will create way too many nodes, under /sys/class/thermal/zoneX/.
> 
> What is "too many"?  20000?  50000?  How many are we talking about here?

Not in 1000's though..

> What is the limiting factor that is preventing this from all going into
> one directory?

We support a MAX of 12 sensors per zone today, which will lead to
12 * 4, 48 nodes under this directory named
sensorY_trip_[active/passive/hot/crit], besides the other nodes.

Thanks,
Durga
