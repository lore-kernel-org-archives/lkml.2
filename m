Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab3AJMu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:50:27 -0500
Received: from mga01.intel.com ([192.55.52.88]:13781 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849Ab3AJMuZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:50:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,443,1355126400"; 
   d="scan'208";a="272230356"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "Zhang, Rui" <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eduardo.valentin@ti.com" <eduardo.valentin@ti.com>,
        "hongbo.zhang@linaro.org" <hongbo.zhang@linaro.org>,
        "wni@nvidia.com" <wni@nvidia.com>
Subject: RE: [PATCH 5/9] Thermal: Create 'mapX' sysfs node for a zone
Thread-Topic: [PATCH 5/9] Thermal: Create 'mapX' sysfs node for a zone
Thread-Index: AQHN7Kc0wktJ5VkW802wf9egZXpmhZg94uGAgASkYCA=
Date: Thu, 10 Jan 2013 12:50:20 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB59258F6C@BGSMSX101.gar.corp.intel.com>
References: <1357542806-20449-1-git-send-email-durgadoss.r@intel.com>
 <1357542806-20449-6-git-send-email-durgadoss.r@intel.com>
 <20130107192129.GA4465@kroah.com>
In-Reply-To: <20130107192129.GA4465@kroah.com>
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
> From: linux-pm-owner@vger.kernel.org [mailto:linux-pm-
> owner@vger.kernel.org] On Behalf Of Greg KH
> Sent: Tuesday, January 08, 2013 12:51 AM
> To: R, Durgadoss
> Cc: Zhang, Rui; linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org;
> eduardo.valentin@ti.com; hongbo.zhang@linaro.org; wni@nvidia.com
> Subject: Re: [PATCH 5/9] Thermal: Create 'mapX' sysfs node for a zone
> 
> On Mon, Jan 07, 2013 at 12:43:22PM +0530, Durgadoss R wrote:
> > This patch creates a thermal map sysfs node under
> > /sys/class/thermal/zoneX/. This contains
> > entries named map0, map1 .. mapN. Each map has the
> > following space separated values:
> > trip_type sensor_name cdev_name trip_mask weights
> 
> sysfs file are always "one value per file".  This seems to violate that
> rule, so please rework this.

These values together represent the binding information of
sensors and cooling devices in a zone. That's why we put
them in a single file.

>From our previous discussion, I understand we can support
a lot of nodes in sysfs. So, I will work with Rui to see how we can
split this in a meaningful way.

Something like:
map0_trip_type
map0_sensor_name
map0_cdev_name
map0_mask
etc..

Rui, What do you think ?

Thanks,
Durga
