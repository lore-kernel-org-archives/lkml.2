Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab2HIGqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 02:46:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:52787 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754874Ab2HIGqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 02:46:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,738,1336374000"; 
   d="scan'208";a="183480787"
Message-ID: <1344494851.1682.670.camel@rui.sh.intel.com>
Subject: Re: [PATCH] thermal: Fix potential NULL pointer accesses
From: Zhang Rui <rui.zhang@intel.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 09 Aug 2012 14:47:31 +0800
In-Reply-To: <20120809062530.GA3779@roeck-us.net>
References: <1344404205-22861-1-git-send-email-linux@roeck-us.net>
	 <1344473095.1682.641.camel@rui.sh.intel.com>
	 <20120809062530.GA3779@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 三, 2012-08-08 at 23:25 -0700, Guenter Roeck wrote:
> On Thu, Aug 09, 2012 at 08:44:55AM +0800, Zhang Rui wrote:
> > On 二, 2012-08-07 at 22:36 -0700, Guenter Roeck wrote:
> > > The type parameter in thermal_zone_device_register and
> > > thermal_cooling_device_register can be NULL, indicating that no sysfs attribute
> > > for the type should be created. Only call strlen() and strcpy() on type if it is
> > > not NULL.
> > > 
> > > This patch addresses Coverity #102180 and #102182: Dereference before null check
> > > 
> > > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > 
> > Acked-by: Zhang Rui <rui.zhang@intel.com>
> > 
> How do we get this patch upstream ? I thought you'd take it through your tree.
> 
yep.

thanks,
rui
> Thanks,
> Guenter
> 
> > > ---
> > > Applies on top of git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git (thermal).
> > > 
> > >  drivers/thermal/thermal_sys.c |    8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> > > index 5be8728..e69f76d 100644
> > > --- a/drivers/thermal/thermal_sys.c
> > > +++ b/drivers/thermal/thermal_sys.c
> > > @@ -900,7 +900,7 @@ thermal_cooling_device_register(char *type, void *devdata,
> > >  	struct thermal_zone_device *pos;
> > >  	int result;
> > >  
> > > -	if (strlen(type) >= THERMAL_NAME_LENGTH)
> > > +	if (type && strlen(type) >= THERMAL_NAME_LENGTH)
> > >  		return ERR_PTR(-EINVAL);
> > >  
> > >  	if (!ops || !ops->get_max_state || !ops->get_cur_state ||
> > > @@ -917,7 +917,7 @@ thermal_cooling_device_register(char *type, void *devdata,
> > >  		return ERR_PTR(result);
> > >  	}
> > >  
> > > -	strcpy(cdev->type, type);
> > > +	strcpy(cdev->type, type ? : "");
> > >  	mutex_init(&cdev->lock);
> > >  	INIT_LIST_HEAD(&cdev->thermal_instances);
> > >  	cdev->ops = ops;
> > > @@ -1343,7 +1343,7 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
> > >  	int count;
> > >  	int passive = 0;
> > >  
> > > -	if (strlen(type) >= THERMAL_NAME_LENGTH)
> > > +	if (type && strlen(type) >= THERMAL_NAME_LENGTH)
> > >  		return ERR_PTR(-EINVAL);
> > >  
> > >  	if (trips > THERMAL_MAX_TRIPS || trips < 0 || mask >> trips)
> > > @@ -1365,7 +1365,7 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
> > >  		return ERR_PTR(result);
> > >  	}
> > >  
> > > -	strcpy(tz->type, type);
> > > +	strcpy(tz->type, type ? : "");
> > >  	tz->ops = ops;
> > >  	tz->device.class = &thermal_class;
> > >  	tz->devdata = devdata;
> > 
> > 
> > 


