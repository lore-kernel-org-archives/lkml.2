Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab2IZOkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 10:40:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:9813 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755926Ab2IZOkF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 10:40:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,490,1344236400"; 
   d="scan'208";a="198094087"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "Zhang, Rui" <rui.zhang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Thermal: Update binding logic based on platform data
Thread-Topic: Thermal: Update binding logic based on platform data
Thread-Index: AQHNm1xNNGcqo2xlFEiG+5KMflFOL5ecsiGQ
Date: Wed, 26 Sep 2012 14:39:22 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB591D3756@BGSMSX101.gar.corp.intel.com>
References: <20120925202747.GA19537@elgon.mountain>
In-Reply-To: <20120925202747.GA19537@elgon.mountain>
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

Hi,

> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Wednesday, September 26, 2012 1:58 AM
> To: R, Durgadoss
> Cc: Zhang, Rui; linux-kernel@vger.kernel.org
> Subject: re: Thermal: Update binding logic based on platform data
> 
> Hello Durgadoss R,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> The patch 9b70dfa68ae8: "Thermal: Update binding logic based on
> platform data" from Sep 18, 2012, leads to the following Smatch
> complaint:

looking into this. Will submit appropriate fix patches soon.

Is there a way for me to check/verify these kind of warnings from
my side ? This way, I can do the check before I submit each patch.

Thanks,
Durga

> 
> drivers/thermal/thermal_sys.c:292 bind_tz()
> 	 error: we previously assumed 'tzp' could be null (see line 283)
> 
> drivers/thermal/thermal_sys.c
>    282		/* If there is no platform data, try to use ops->bind */
>    283		if (!tzp && tz->ops->bind) {
>                     ^^^^
> New check.
> 
>    284			list_for_each_entry(pos, &thermal_cdev_list, node)
> {
>    285				ret = tz->ops->bind(tz, pos);
>    286				if (ret)
>    287					print_bind_err_msg(tz, pos, ret);
>    288			}
>    289			goto exit;
>    290		}
>    291
>    292		if (!tzp->tbp)
>                      ^^^^^^^^
> New dereference.
> 
>    293			goto exit;
>    294
> 
> There are also some locking bugs which need to be fixed as well.
> 
> drivers/thermal/thermal_sys.c:268 bind_cdev() warn: inconsistent returns
> mutex:&thermal_list_lock: locked (256) unlocked (268)
> drivers/thermal/thermal_sys.c:396 update_temperature() warn:
> inconsistent returns mutex:&tz->lock: locked (390) unlocked (396)
> 
> regards,
> dan carpenter
> 

