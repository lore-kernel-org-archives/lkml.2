Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab3AJO17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 09:27:59 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:43415 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab3AJO1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 09:27:55 -0500
Date: Thu, 10 Jan 2013 06:28:29 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "R, Durgadoss" <durgadoss.r@intel.com>
Cc: "Zhang, Rui" <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eduardo.valentin@ti.com" <eduardo.valentin@ti.com>,
        "hongbo.zhang@linaro.org" <hongbo.zhang@linaro.org>,
        "wni@nvidia.com" <wni@nvidia.com>
Subject: Re: [PATCH 5/9] Thermal: Create 'mapX' sysfs node for a zone
Message-ID: <20130110142829.GB15787@kroah.com>
References: <1357542806-20449-1-git-send-email-durgadoss.r@intel.com>
 <1357542806-20449-6-git-send-email-durgadoss.r@intel.com>
 <20130107192129.GA4465@kroah.com>
 <4D68720C2E767A4AA6A8796D42C8EB59258F6C@BGSMSX101.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D68720C2E767A4AA6A8796D42C8EB59258F6C@BGSMSX101.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 12:50:20PM +0000, R, Durgadoss wrote:
> > -----Original Message-----
> > From: linux-pm-owner@vger.kernel.org [mailto:linux-pm-
> > owner@vger.kernel.org] On Behalf Of Greg KH
> > Sent: Tuesday, January 08, 2013 12:51 AM
> > To: R, Durgadoss
> > Cc: Zhang, Rui; linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > eduardo.valentin@ti.com; hongbo.zhang@linaro.org; wni@nvidia.com
> > Subject: Re: [PATCH 5/9] Thermal: Create 'mapX' sysfs node for a zone
> > 
> > On Mon, Jan 07, 2013 at 12:43:22PM +0530, Durgadoss R wrote:
> > > This patch creates a thermal map sysfs node under
> > > /sys/class/thermal/zoneX/. This contains
> > > entries named map0, map1 .. mapN. Each map has the
> > > following space separated values:
> > > trip_type sensor_name cdev_name trip_mask weights
> > 
> > sysfs file are always "one value per file".  This seems to violate that
> > rule, so please rework this.
> 
> These values together represent the binding information of
> sensors and cooling devices in a zone. That's why we put
> them in a single file.

That doesn't matter, it's still multiple values in a single file that
has to be parsed now.

> >From our previous discussion, I understand we can support
> a lot of nodes in sysfs. So, I will work with Rui to see how we can
> split this in a meaningful way.
> 
> Something like:
> map0_trip_type
> map0_sensor_name
> map0_cdev_name
> map0_mask
> etc..

That would be much better.

thanks,

greg k-h
