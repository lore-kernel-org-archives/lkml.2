Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab2FDCz1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 22:55:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:53634 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755615Ab2FDCz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 22:55:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="160183976"
Message-ID: <1338778611.1472.265.camel@rui.sh.intel.com>
Subject: Re: thermal_zone trip_point_0_temp =?ISO-8859-1?Q?200=B0C?=
From: Zhang Rui <rui.zhang@intel.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Mark B <markieb.lists.20090330@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 04 Jun 2012 10:56:51 +0800
In-Reply-To: <4FC9D021.1030207@ladisch.de>
References: <CABAQT1ChtWVauLisaRk_KpN3JSWsvUXKKWDTAW6yuW-G32vmMw@mail.gmail.com>
	 <4FC9D021.1030207@ladisch.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 六, 2012-06-02 at 10:34 +0200, Clemens Ladisch wrote:
> Mark B wrote:
> > My Acer Aspire 5552-7260, AMD phenom II N970 cpu, is giving me very
> > bizarre temp limit readings; the main reason I'm noticing it is that
> > it is heating up to 70° without much of a load, 63° at startup under
> > virtually no load; works well in windows, 48° as equivalent to the
> > linux 63°, so my gradual conclusion is that it's some kernel-level
> > code that needs changing?
> >
> > Can't fancontrol/pwmconfig as apparently — from my limited knowledge
> > of how to double-check, I've tried looking in all the relevant /sys
> > nodes — there are no pwm-capable fans; lm_sensors, however, gives the
> > 200°C temp limit as does acpiclient; I'm noticing that there are some
> > kernel patches affecting the area, although it is unclear to me how
> > far that would even make it the kernel's responsibility; I've tried
> > all the acpi_osi=Linux, acpi_osi="Linux", acpi_osi=\\\"Linux\\\",
> > acpi_enforce_resources=lax, acpi.power_nocheck=1 alternatives without
> > sign of change; as I recalled from my eeepc that that was the way of
> > preventing the newer, non-fully-functional, acpi kernel module, from
> > loading, forcing legacy acpi/pwm support; in fact the overheating
> > eeepc is one more reason I'm writing to the kernel list now, as I'm
> > seeing a kind of pattern of computers overheating in linux when in
> > principle all that it should need would be faster fan speeds / lower
> > soft limits;
> >
> > Looking carefully at the modules list, I see k10temp as the most
> > obvious sensor module, unsure how relevant that is
> 
> The k10temp module provides nothing but a sensor for monitoring
> applications.  Your thermal zones are managed by the acpitz driver,
> which is compiled into the kernel and uses its own sensor.
> 
> > my understanding of it is that the Kernel/the Bios manages the fan
> > speed in 'automatic' mode, as distinguished from fancontrol-type
> > 'manual' mode; given that windows manages it properly, I'd have to
> > conclude it wouldn't normally be the Bios's fault?
> 
> The ACPI tables are provided by the BIOS.
> 
yes.
Usually, the critical trip point value is a hard coded number provided
by the BIOS.
About fan control, it seems that there is no ACPI FAN on this machine,
so the fan may be controlled either by firmware or by some platform
specific driver.
To make a double check, it would be great if you can refer to
http://www.lesswatts.org/projects/acpi/utilities.php
to get the acpidump output of this machine.

thanks,
rui

> For documentation about the thermal zone files, see
> <Documentation/thermal/sysfs-api.txt>.
> 
> > $ cat /proc/version
> > Linux version 3.3.7-1.fc17.x86_64
> > (mockbuild@x86-11.phx2.fedoraproject.org) (gcc version 4.7.0 20120507
> > (Red Hat 4.7.0-5) (GCC) ) #1 SMP Mon May 21 22:32:19 UTC 2012
> >
> > $ grep -r . /sys/class/thermal/thermal_zone*
> > /sys/class/thermal/thermal_zone0/power/async:disabled
> > /sys/class/thermal/thermal_zone0/power/runtime_status:unsupported
> > /sys/class/thermal/thermal_zone0/power/runtime_usage:0
> > /sys/class/thermal/thermal_zone0/power/runtime_active_kids:0
> > /sys/class/thermal/thermal_zone0/power/runtime_enabled:disabled
> > /sys/class/thermal/thermal_zone0/power/control:auto
> > /sys/class/thermal/thermal_zone0/power/runtime_suspended_time:0
> > /sys/class/thermal/thermal_zone0/power/runtime_active_time:0
> > grep: /sys/class/thermal/thermal_zone0/power/autosuspend_delay_ms:
> > Input/output error
> > /sys/class/thermal/thermal_zone0/type:acpitz
> > /sys/class/thermal/thermal_zone0/temp:62000
> > /sys/class/thermal/thermal_zone0/mode:enabled
> > /sys/class/thermal/thermal_zone0/trip_point_0_type:critical
> > /sys/class/thermal/thermal_zone0/trip_point_0_temp:200000
> > /sys/class/thermal/thermal_zone0/trip_point_1_type:passive
> > /sys/class/thermal/thermal_zone0/trip_point_1_temp:90000
> > /sys/class/thermal/thermal_zone0/cdev0_trip_point:1
> > /sys/class/thermal/thermal_zone0/cdev1_trip_point:1
> > /sys/class/thermal/thermal_zone0/cdev2_trip_point:1
> > /sys/class/thermal/thermal_zone0/cdev3_trip_point:1
> 
> 
> Regards,
> Clemens


