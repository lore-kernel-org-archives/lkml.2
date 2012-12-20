Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab2LTGEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 01:04:20 -0500
Received: from mga14.intel.com ([143.182.124.37]:21217 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838Ab2LTGEI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 01:04:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,322,1355126400"; 
   d="scan'208";a="234343460"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Joe Perches <joe@perches.com>
CC: "Zhang, Rui" <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hongbo.zhang@linaro.org" <hongbo.zhang@linaro.org>,
        "wni@nvidia.com" <wni@nvidia.com>
Subject: RE: [PATCH 2/8] Thermal: Create zone level APIs
Thread-Topic: [PATCH 2/8] Thermal: Create zone level APIs
Thread-Index: AQHN3QLeFpdg6ZOjSUaJifj4WR1pyJgeD94AgAMlJJA=
Date: Thu, 20 Dec 2012 06:02:36 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB5924C5D9@BGSMSX101.gar.corp.intel.com>
References: <1355822977-4804-1-git-send-email-durgadoss.r@intel.com>
	 <1355822977-4804-3-git-send-email-durgadoss.r@intel.com>
 <1355830214.19706.39.camel@joe-AO722>
In-Reply-To: <1355830214.19706.39.camel@joe-AO722>
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

Hi Joe,

> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Tuesday, December 18, 2012 5:00 PM
> To: R, Durgadoss
> Cc: Zhang, Rui; linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org;
> hongbo.zhang@linaro.org; wni@nvidia.com
> Subject: Re: [PATCH 2/8] Thermal: Create zone level APIs
> 
> On Tue, 2012-12-18 at 14:59 +0530, Durgadoss R wrote:
> > This patch adds a new thermal_zone structure to
> > thermal.h. Also, adds zone level APIs to the thermal
> > framework.
> 
> []
> 
> > diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> 
> > +#define GET_INDEX(tz, ptr, indx, type)			\
> > +	do {						\
> > +		int i;					\
> > +		indx = -EINVAL;				\
> > +		if (!tz || !ptr)			\
> > +			break;				\
> > +		mutex_lock(&type##_list_lock);		\
> > +		for (i = 0; i < tz->type##_indx; i++) {	\
> > +			if (tz->type##s[i] == ptr) {	\
> > +				indx = i;		\
> > +				break;			\
> > +			}				\
> > +		}					\
> > +		mutex_unlock(&type##_list_lock);	\
> > +	} while (0)
> 
> A statement expression macro returning int would be
> more kernel style like and better to use.
> 

Yes, makes sense. Will fix this in next rev.

Thanks,
Durga

> (sorry about the whitespace, evolution 3.6 is crappy)
> 
> #define GET_INDEX(tx, ptr, type)				\
> ({								\
> 	int rtn = -EINVAL;					\
> 	do {							\
> 		int i;						\
> 		if (!tz || !ptr)				\
> 			break;					\
> 		mutex_lock(&type##_list_lock);			\
> 		for (i = 0; i < tz->type##_indx; i++) {		\
> 			if (tz->type##s[i] == ptr) {		\
> 				rtn = i;			\
> 				break;				\
> 			}					\
> 		}						\
> 		mutex_unlock(&type##_list_lock);		\
> 	} while (0);						\
> 	rtn;							\
> })
> 
> 
> > +static void remove_sensor_from_zone(struct thermal_zone *tz,
> > +				struct thermal_sensor *ts)
> > +{
> > +	int j, indx;
> > +
> > +	GET_INDEX(tz, ts, indx, sensor);
> 
> This becomes
> 
> 	indx = GET_INDEX(tx, ts, sensor);
> 
> > +	if (indx < 0)
> > +		return;
> 

