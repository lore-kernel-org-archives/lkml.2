Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab2IXI5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 04:57:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:14477 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab2IXI5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 04:57:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,474,1344236400"; 
   d="scan'208";a="225674810"
Message-ID: <1348477068.10877.180.camel@rui.sh.intel.com>
Subject: RE: [PATCH] Thermal: Fix bug on generic thermal framework.
From: Zhang Rui <rui.zhang@intel.com>
To: "R, Durgadoss" <durgadoss.r@intel.com>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>,
        "linux-pml@vger.kernel.org" <linux-pml@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Amit Kachhap <amit.kachhap@linaro.org>
Date: Mon, 24 Sep 2012 16:57:48 +0800
In-Reply-To: <4D68720C2E767A4AA6A8796D42C8EB591C98E6@BGSMSX102.gar.corp.intel.com>
References: <1348452350-1021-1-git-send-email-jonghwa3.lee@samsung.com>
	 <4D68720C2E767A4AA6A8796D42C8EB591C98E6@BGSMSX102.gar.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 一, 2012-09-24 at 02:08 -0600, R, Durgadoss wrote:
> Hi,
> 
> Patch is fine, but I think you have to re-base on top of
> Rui's -next branch here:
> git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git
> 
> Also, adding Rui to this mail, not sure whether he is in LKML/pm.
> 
> Thanks,
> Durga
> 
> > -----Original Message-----
> > From: Jonghwa Lee [mailto:jonghwa3.lee@samsung.com]
> > Sent: Monday, September 24, 2012 7:36 AM
> > To: linux-pml@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org; Brown, Len; Rafael J. Wysocki; Andrew
> > Morton; Amit Kachhap; R, Durgadoss; Jonghwa Lee
> > Subject: [PATCH] Thermal: Fix bug on generic thermal framework.
> > 
> > When system fails to bind cooling devices to thermal zone device during
> > registering thermal zone device, it leaves registering without canceling
> > delayed work. It probably makes panic if polling rate is not enough to release
> > that work from workqueue. So it is better to ignore initialization of polling
> > work to prevent that unexpected state.
> > 
Hi, Jonghwa,

I still do not understand what the problem is.
Say if a cooling device fails to bind, the thermal zone device would
still work properly, just like the failure cooling device is not
referenced in this thermal zone.

thanks,
rui
> > Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> > ---
> >  drivers/thermal/thermal_sys.c |    6 ++++--
> >  1 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> > index 2ab31e4..744e69d 100644
> > --- a/drivers/thermal/thermal_sys.c
> > +++ b/drivers/thermal/thermal_sys.c
> > @@ -1351,12 +1351,14 @@ struct thermal_zone_device
> > *thermal_zone_device_register(const char *type,
> >  		}
> >  	mutex_unlock(&thermal_list_lock);
> > 
> > +	if (result)
> > +		goto unregister;
> > +
> >  	INIT_DELAYED_WORK(&(tz->poll_queue),
> > thermal_zone_device_check);
> > 
> >  	thermal_zone_device_update(tz);
> > 
> > -	if (!result)
> > -		return tz;
> > +	return tz;
> > 
> >  unregister:
> >  	release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
> > --
> > 1.7.4.1
> 



