Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab2IJUUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 16:20:33 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:46404 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932144Ab2IJUU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 16:20:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH RESEND] thermal: add generic cpufreq cooling implementation
Date: Mon, 10 Sep 2012 22:26:45 +0200
User-Agent: KMail/1.13.6 (Linux/3.6.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: linux-samsung-soc@vger.kernel.org, Kyungmin Park <kmpark@infradead.org>,
        SangWook Ju <sw.ju@samsung.com>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, linux-acpi@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
References: <1347258341.1682.1062.camel@rui.sh.intel.com> <201209102223.53094.rjw@sisk.pl>
In-Reply-To: <201209102223.53094.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201209102226.45739.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 10, 2012, Rafael J. Wysocki wrote:
> On Monday, September 10, 2012, Zhang Rui wrote:
> > Refreshed to remove the notifier mechanism as we do not have a real user of it.
> > if there is no problem, I'll apply the whole patch set to thermal next tree.
> > 
> > From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
> > Date: Thu, 16 Aug 2012 17:11:40 +0530
> > 
> > This patchset introduces a new generic cooling device based on cpufreq
> > that can be used on non-ACPI platforms.  As a proof of concept, we have
> > drivers for the following platforms using this mechanism now:
> > 
> >  * Samsung Exynos (Exynos4 and Exynos5) in the current patchset.
> >  * Freescale i.MX (git://git.linaro.org/people/amitdanielk/linux.git imx6q_thermal)
> > 
> > There is a small change in cpufreq cooling registration APIs, so a minor
> > change is needed for Freescale platforms.
> > 
> > Brief Description:
> > 
> > 1) The generic cooling devices code is placed inside driver/thermal/*
> >    as placing inside acpi folder will need un-necessary enabling of acpi
> >    code.  This code is architecture independent.
> > 
> > 2) This patchset adds generic cpu cooling low level implementation
> >    through frequency clipping.  In future, other cpu related cooling
> >    devices may be added here.  An ACPI version of this already exists
> >    (drivers/acpi/processor_thermal.c) .But this will be useful for
> >    platforms like ARM using the generic thermal interface along with the
> >    generic cpu cooling devices.  The cooling device registration API's
> >    return cooling device pointers which can be easily binded with the
> >    thermal zone trip points.  The important APIs exposed are,
> > 
> >    a) struct thermal_cooling_device *cpufreq_cooling_register(
> >         struct cpumask *clip_cpus)
> >    b) void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
> > 
> > 3) Samsung exynos platform thermal implementation is done using the
> >    generic cpu cooling APIs and the new trip type.  The temperature sensor
> >    driver present in the hwmon folder(registered as hwmon driver) is moved
> >    to thermal folder and registered as a thermal driver.
> > 
> > A simple data/control flow diagrams is shown below,
> > 
> > Core Linux thermal <----->  Exynos thermal interface <----- Temperature Sensor
> >           |                             |
> >          \|/                            |
> >   Cpufreq cooling device <---------------
> > 
> > TODO:
> > *Will send the DT enablement patches later after the driver is merged.
> > 
> > This patch:
> > 
> > Add support for generic cpu thermal cooling low level implementations
> > using frequency scaling up/down based on the registration parameters.
> > Different cpu related cooling devices can be registered by the user and
> > the binding of these cooling devices to the corresponding trip points can
> > be easily done as the registration APIs return the cooling device pointer.
> > The user of these APIs are responsible for passing clipping frequency .
> > The drivers can also register to recieve notification about any cooling
> > action called.
> > 
> > Cc: Guenter Roeck <guenter.roeck@ericsson.com>
> > Cc: SangWook Ju <sw.ju@samsung.com>
> > Cc: Durgadoss <durgadoss.r@intel.com>
> > Cc: Len Brown <lenb@kernel.org>
> > Cc: Jean Delvare <khali@linux-fr.org>
> > Cc: Kyungmin Park <kmpark@infradead.org>
> > Cc: Kukjin Kim <kgene.kim@samsung.com>
> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> 
> Can you please resend the patch inline (i.e. not as an attachment)?

Sorry, it was inline (obviously).  I seem to be too tired.

Please resend it to linux-pm@vger.kernel.org.  The linux-pm list at
linux-foundation.org is not functional any more.

Thanks,
Rafael
