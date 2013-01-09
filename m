Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab3AIJVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 04:21:49 -0500
Received: from mga14.intel.com ([143.182.124.37]:46864 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757420Ab3AIJVr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 04:21:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,436,1355126400"; 
   d="scan'208";a="189213783"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "Zhang, Rui" <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eduardo.valentin@ti.com" <eduardo.valentin@ti.com>,
        "hongbo.zhang@linaro.org" <hongbo.zhang@linaro.org>,
        "wni@nvidia.com" <wni@nvidia.com>
Subject: RE: [PATCH 3/9] Thermal: Add APIs to bind cdev to new zone structure
Thread-Topic: [PATCH 3/9] Thermal: Add APIs to bind cdev to new zone
 structure
Thread-Index: AQHN7KcyF7lH+7Q3LUOsStvbOJGAIpg95CYAgALWLHA=
Date: Wed, 9 Jan 2013 09:21:23 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB59257F38@BGSMSX101.gar.corp.intel.com>
References: <1357542806-20449-1-git-send-email-durgadoss.r@intel.com>
 <1357542806-20449-4-git-send-email-durgadoss.r@intel.com>
 <20130107192602.GD4465@kroah.com>
In-Reply-To: <20130107192602.GD4465@kroah.com>
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
> Sent: Tuesday, January 08, 2013 12:56 AM
> To: R, Durgadoss
> Cc: Zhang, Rui; linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org;
> eduardo.valentin@ti.com; hongbo.zhang@linaro.org; wni@nvidia.com
> Subject: Re: [PATCH 3/9] Thermal: Add APIs to bind cdev to new zone
> structure
> 
> On Mon, Jan 07, 2013 at 12:43:20PM +0530, Durgadoss R wrote:
> > +struct thermal_cooling_device *get_cdev_by_name(const char *name)
> > +{
> > +	struct thermal_cooling_device *pos;
> > +	struct thermal_cooling_device *cdev = NULL;
> > +
> > +	mutex_lock(&cdev_list_lock);
> > +	for_each_cdev(pos) {
> > +		if (!strnicmp(pos->type, name, THERMAL_NAME_LENGTH)) {
> > +			cdev = pos;
> > +			break;
> > +		}
> > +	}
> > +	mutex_unlock(&cdev_list_lock);
> > +	return cdev;
> > +}
> > +EXPORT_SYMBOL(get_cdev_by_name);
> 
> EXPORT_SYMBOL_GPL?

We have all other exports as EXPORT_SYMBOL in this file(thermal_sys.c)
If _GPL is required, the we will do a single patch changing all of them to
EXPORT_SYMBOL_GPL.

> 
> You also forgot to increment the reference count, which is required for
> all reference counted objects.

Sorry, I could not get what you are saying here.

Thanks,
Durga
