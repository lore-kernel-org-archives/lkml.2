Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966564Ab2FBIfS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 04:35:18 -0400
Received: from smtprelay01.ispgateway.de ([80.67.31.35]:46178 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966544Ab2FBIfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 04:35:12 -0400
Message-ID: <4FC9D021.1030207@ladisch.de>
Date: Sat, 02 Jun 2012 10:34:41 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Mark B <markieb.lists.20090330@gmail.com>, Zhang Rui <rui.zhang@intel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: thermal_zone trip_point_0_temp =?UTF-8?B?MjAwwrBD?=
References: <CABAQT1ChtWVauLisaRk_KpN3JSWsvUXKKWDTAW6yuW-G32vmMw@mail.gmail.com>
In-Reply-To: <CABAQT1ChtWVauLisaRk_KpN3JSWsvUXKKWDTAW6yuW-G32vmMw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark B wrote:
> My Acer Aspire 5552-7260, AMD phenom II N970 cpu, is giving me very
> bizarre temp limit readings; the main reason I'm noticing it is that
> it is heating up to 70° without much of a load, 63° at startup under
> virtually no load; works well in windows, 48° as equivalent to the
> linux 63°, so my gradual conclusion is that it's some kernel-level
> code that needs changing?
>
> Can't fancontrol/pwmconfig as apparently — from my limited knowledge
> of how to double-check, I've tried looking in all the relevant /sys
> nodes — there are no pwm-capable fans; lm_sensors, however, gives the
> 200°C temp limit as does acpiclient; I'm noticing that there are some
> kernel patches affecting the area, although it is unclear to me how
> far that would even make it the kernel's responsibility; I've tried
> all the acpi_osi=Linux, acpi_osi="Linux", acpi_osi=\\\"Linux\\\",
> acpi_enforce_resources=lax, acpi.power_nocheck=1 alternatives without
> sign of change; as I recalled from my eeepc that that was the way of
> preventing the newer, non-fully-functional, acpi kernel module, from
> loading, forcing legacy acpi/pwm support; in fact the overheating
> eeepc is one more reason I'm writing to the kernel list now, as I'm
> seeing a kind of pattern of computers overheating in linux when in
> principle all that it should need would be faster fan speeds / lower
> soft limits;
>
> Looking carefully at the modules list, I see k10temp as the most
> obvious sensor module, unsure how relevant that is

The k10temp module provides nothing but a sensor for monitoring
applications.  Your thermal zones are managed by the acpitz driver,
which is compiled into the kernel and uses its own sensor.

> my understanding of it is that the Kernel/the Bios manages the fan
> speed in 'automatic' mode, as distinguished from fancontrol-type
> 'manual' mode; given that windows manages it properly, I'd have to
> conclude it wouldn't normally be the Bios's fault?

The ACPI tables are provided by the BIOS.

For documentation about the thermal zone files, see
<Documentation/thermal/sysfs-api.txt>.

> $ cat /proc/version
> Linux version 3.3.7-1.fc17.x86_64
> (mockbuild@x86-11.phx2.fedoraproject.org) (gcc version 4.7.0 20120507
> (Red Hat 4.7.0-5) (GCC) ) #1 SMP Mon May 21 22:32:19 UTC 2012
>
> $ grep -r . /sys/class/thermal/thermal_zone*
> /sys/class/thermal/thermal_zone0/power/async:disabled
> /sys/class/thermal/thermal_zone0/power/runtime_status:unsupported
> /sys/class/thermal/thermal_zone0/power/runtime_usage:0
> /sys/class/thermal/thermal_zone0/power/runtime_active_kids:0
> /sys/class/thermal/thermal_zone0/power/runtime_enabled:disabled
> /sys/class/thermal/thermal_zone0/power/control:auto
> /sys/class/thermal/thermal_zone0/power/runtime_suspended_time:0
> /sys/class/thermal/thermal_zone0/power/runtime_active_time:0
> grep: /sys/class/thermal/thermal_zone0/power/autosuspend_delay_ms:
> Input/output error
> /sys/class/thermal/thermal_zone0/type:acpitz
> /sys/class/thermal/thermal_zone0/temp:62000
> /sys/class/thermal/thermal_zone0/mode:enabled
> /sys/class/thermal/thermal_zone0/trip_point_0_type:critical
> /sys/class/thermal/thermal_zone0/trip_point_0_temp:200000
> /sys/class/thermal/thermal_zone0/trip_point_1_type:passive
> /sys/class/thermal/thermal_zone0/trip_point_1_temp:90000
> /sys/class/thermal/thermal_zone0/cdev0_trip_point:1
> /sys/class/thermal/thermal_zone0/cdev1_trip_point:1
> /sys/class/thermal/thermal_zone0/cdev2_trip_point:1
> /sys/class/thermal/thermal_zone0/cdev3_trip_point:1


Regards,
Clemens
