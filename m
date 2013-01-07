Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab3AGIxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 03:53:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:64411 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860Ab3AGIxL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 03:53:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,423,1355126400"; 
   d="scan'208";a="268528624"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Wei Ni <wni@nvidia.com>
CC: "Zhang, Rui" <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eduardo.valentin@ti.com" <eduardo.valentin@ti.com>,
        "hongbo.zhang@linaro.org" <hongbo.zhang@linaro.org>
Subject: RE: [PATCH 6/9] Thermal: Add Documentation to new APIs
Thread-Topic: [PATCH 6/9] Thermal: Add Documentation to new APIs
Thread-Index: AQHN7Kc3JhEwqi1AgEGu7eU5KNSPrJg9L8UAgABe2CA=
Date: Mon, 7 Jan 2013 08:53:07 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB5925668A@BGSMSX101.gar.corp.intel.com>
References: <1357542806-20449-1-git-send-email-durgadoss.r@intel.com>
 <1357542806-20449-7-git-send-email-durgadoss.r@intel.com>
 <50EA89FA.6010703@nvidia.com>
In-Reply-To: <50EA89FA.6010703@nvidia.com>
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
> From: Wei Ni [mailto:wni@nvidia.com]
> Sent: Monday, January 07, 2013 2:10 PM
> To: R, Durgadoss
> Cc: Zhang, Rui; linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org;
> eduardo.valentin@ti.com; hongbo.zhang@linaro.org
> Subject: Re: [PATCH 6/9] Thermal: Add Documentation to new APIs
> 
> On 01/07/2013 03:13 PM, Durgadoss R wrote:
> > This patch adds Documentation for the new APIs
> > introduced in this patch set. The documentation
> > also has a model sysfs structure for reference.
> >
> > Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
> > ---
> >  Documentation/thermal/sysfs-api2.txt |  248
> ++++++++++++++++++++++++++++++++++
> >  1 file changed, 248 insertions(+)
> >  create mode 100644 Documentation/thermal/sysfs-api2.txt
> >
> > diff --git a/Documentation/thermal/sysfs-api2.txt
> b/Documentation/thermal/sysfs-api2.txt
> > new file mode 100644
> > index 0000000..ffd0402
> > --- /dev/null
> > +++ b/Documentation/thermal/sysfs-api2.txt
> > @@ -0,0 +1,248 @@
> > +Thermal Framework
> > +-----------------
> > +
> > +Written by Durgadoss R <durgadoss.r@intel.com>
> > +Copyright (c) 2012 Intel Corporation
> > +
> > +Created on: 4 November 2012
> > +Updated on: 18 December 2012
> > +
> > +0. Introduction
> > +---------------
> > +The Linux thermal framework provides a set of interfaces for thermal
> > +sensors and thermal cooling devices (fan, processor...) to register
> > +with the thermal management solution and to be a part of it.
> > +
> > +This document focuses on how to enable new thermal sensors and
> cooling
> > +devices to participate in thermal management. This solution is intended
> > +to be 'light-weight' and platform/architecture independent. Any thermal
> > +sensor/cooling device should be able to use the infrastructure easily.
> > +
> > +The goal of thermal framework is to expose the thermal sensor/zone and
> > +cooling device attributes in a consistent way. This will help the
> > +thermal governors to make use of the information to manage platform
> > +thermals efficiently.
> > +
> > +The thermal sensor source file can be generic (can be any sensor driver,
> > +in any subsystem). This driver will use the sensor APIs and register with
> > +thermal framework to participate in platform Thermal management. This
> > +does not (and should not) know about which zone it belongs to, or any
> > +other information about platform thermals. A sensor driver is a
> standalone
> > +piece of code, which can optionally register with thermal framework.
> > +
> > +However, for any platform, there should be a platformX_thermal.c file,
> > +which will know about the platform thermal characteristics (like how many
> > +sensors, zones, cooling devices, etc.. And how they are related to each
> other
> > +i.e the mapping information). Only in this file, the zone level APIs should
> > +be used, in which case the file will have all information required to attach
> > +various sensors to a particular zone.
> > +
> > +This way, we can have one platform level thermal file, which can support
> > +multiple platforms (may be)using the same set of sensors (but)binded in
> > +a different way. This file can get the platform thermal information
> > +through Firmware, ACPI tables, device tree etc.
> > +
> > +Unfortunately, today we don't have many drivers that can be clearly
> > +differentiated as 'sensor_file.c' and 'platform_thermal_file.c'.
> > +But very soon we will need/have. The reason I am saying this is because
> > +we are seeing a lot of chip drivers, starting to use thermal framework,
> > +and we should keep it really light-weight for them to do so.
> > +
> > +An Example: drivers/hwmon/emc1403.c - a generic thermal chip driver
> > +In one platform this sensor can belong to 'ZoneA' and in another the
> > +same can belong to 'ZoneB'. But, emc1403.c does not really care about
> > +where does it belong. It just reports temperature.
> > +
> > +1. Terminology
> > +--------------
> > +This section describes the terminology used in the rest of this
> > +document as well as the thermal framework code.
> > +
> > +thermal_sensor: Hardware that can report temperature of a particular
> > +               spot in the platform, where it is placed. The temperature
> > +               reported by the sensor is the 'real' temperature reported
> > +               by the hardware.
> > +thermal_zone:  A virtual area on the device, that gets heated up. It may
> > +               have one or more thermal sensors attached to it.
> > +cooling_device:        Any component that can help in reducing the
> temperature of
> > +               a 'hot spot' either by reducing its performance (passive
> > +               cooling) or by other means(Active cooling E.g. Fan)
> > +
> > +trip_points:   Various temperature levels for each sensor. As of now, we
> > +               have four levels namely active, passive, hot and critical.
> > +               Hot and critical trip point support only one value whereas
> > +               active and passive can have any number of values. These
> > +               temperature values can come from platform data, and are
> > +               exposed through sysfs in a consistent manner. Stand-alone
> > +               thermal sensor drivers are not expected to know these values.
> > +               These values are RO.
> > +thresholds:    These are programmable temperature limits, on reaching
> which
> > +               the thermal sensor generates an interrupt. The framework is
> > +               notified about this interrupt to take appropriate action.
> > +               There can be as many number of thresholds as that of the
> > +               hardware supports. These values are RW.
> 
> Hi,
> When generate interrupt, we could call something like
> notify_thermal_framework(), is it right? but it just notify the
> framework, how to notify the platform driver? I think the platform
> driver will wish to update the limited values when interrupt occur.
> Will we have a thermal zone fops like ops.notify()?
> I noticed there have "struct thermal_zone *ops" in the thermal_zone
> structure, will it be used for callback?

Yes, you are right. I missed adding a .notify() call back to thermal_zone ops.
I will wait to see if we get more comments on this version of the patches.
If so, will fix this in v3. Otherwise, will submit a patch, once these
patches make it to Rui's tree. Hope this works for you :-)

Thanks,
Durga
