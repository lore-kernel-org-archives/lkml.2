Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab3AIRBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 12:01:31 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:35049 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932298Ab3AIRB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 12:01:28 -0500
Date: Wed, 9 Jan 2013 09:01:23 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "R, Durgadoss" <durgadoss.r@intel.com>
Cc: "Zhang, Rui" <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eduardo.valentin@ti.com" <eduardo.valentin@ti.com>,
        "hongbo.zhang@linaro.org" <hongbo.zhang@linaro.org>,
        "wni@nvidia.com" <wni@nvidia.com>
Subject: Re: [PATCH 3/9] Thermal: Add APIs to bind cdev to new zone structure
Message-ID: <20130109170123.GB7068@kroah.com>
References: <1357542806-20449-1-git-send-email-durgadoss.r@intel.com>
 <1357542806-20449-4-git-send-email-durgadoss.r@intel.com>
 <20130107192602.GD4465@kroah.com>
 <4D68720C2E767A4AA6A8796D42C8EB59257F38@BGSMSX101.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D68720C2E767A4AA6A8796D42C8EB59257F38@BGSMSX101.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 09:21:23AM +0000, R, Durgadoss wrote:
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Tuesday, January 08, 2013 12:56 AM
> > To: R, Durgadoss
> > Cc: Zhang, Rui; linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > eduardo.valentin@ti.com; hongbo.zhang@linaro.org; wni@nvidia.com
> > Subject: Re: [PATCH 3/9] Thermal: Add APIs to bind cdev to new zone
> > structure
> > 
> > On Mon, Jan 07, 2013 at 12:43:20PM +0530, Durgadoss R wrote:
> > > +struct thermal_cooling_device *get_cdev_by_name(const char *name)
> > > +{
> > > +	struct thermal_cooling_device *pos;
> > > +	struct thermal_cooling_device *cdev = NULL;
> > > +
> > > +	mutex_lock(&cdev_list_lock);
> > > +	for_each_cdev(pos) {
> > > +		if (!strnicmp(pos->type, name, THERMAL_NAME_LENGTH)) {
> > > +			cdev = pos;
> > > +			break;
> > > +		}
> > > +	}
> > > +	mutex_unlock(&cdev_list_lock);
> > > +	return cdev;
> > > +}
> > > +EXPORT_SYMBOL(get_cdev_by_name);
> > 
> > EXPORT_SYMBOL_GPL?
> 
> We have all other exports as EXPORT_SYMBOL in this file(thermal_sys.c)
> If _GPL is required, the we will do a single patch changing all of them to
> EXPORT_SYMBOL_GPL.

Fair enough.

> > You also forgot to increment the reference count, which is required for
> > all reference counted objects.
> 
> Sorry, I could not get what you are saying here.

You are doing a "get" call, yet you are failing to increment a reference
count on the object.  That isn't allowed and can cause bad problems.
Please use proper reference counting for your structures.

greg k-h
