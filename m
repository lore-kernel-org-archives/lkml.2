Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab2FCSWd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 14:22:33 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45793 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab2FCSWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 14:22:32 -0400
Message-ID: <4FCBAB57.4030305@gmail.com>
Date: Sun, 03 Jun 2012 14:22:15 -0400
From: Mark <markieb.lists.20090330@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: thermal_zone trip_point_0_temp =?UTF-8?B?MjAwwrBD?=
References: <CABAQT1ChtWVauLisaRk_KpN3JSWsvUXKKWDTAW6yuW-G32vmMw@mail.gmail.com> <4FC9D021.1030207@ladisch.de>
In-Reply-To: <4FC9D021.1030207@ladisch.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Clemens, thanks for writing;

On 06/02/2012 04:34 AM, Clemens Ladisch wrote:
> The k10temp module provides nothing but a sensor for monitoring
> applications.  Your thermal zones are managed by the acpitz driver,
> which is compiled into the kernel and uses its own sensor.
thanks for confirming that, I've noticed that the k10temp, at least as ksensors
interpret it, seems to report a more sensible limit of 80°, although as you say
that's a reporting module that won't affect actual management, I suppose it's
neither here nor there, unless that's a sign that the kernel code is faulty while
the k10temp code is correct — inasmuch as it interprets the readings in
accordance with the BIOS's directions
>> my understanding of it is that the Kernel/the Bios manages the fan
>> speed in 'automatic' mode, as distinguished from fancontrol-type
>> 'manual' mode; given that windows manages it properly, I'd have to
>> conclude it wouldn't normally be the Bios's fault?
> The ACPI tables are provided by the BIOS.
>
> For documentation about the thermal zone files, see
> <Documentation/thermal/sysfs-api.txt>.
yet the documentation for 3.3.7 says 'mode' for instance should be \in [kernel,
user], while the node is reporting 'enabled'
>> $ grep -r . /sys/class/thermal/thermal_zone*
>> /sys/class/thermal/thermal_zone0/power/async:disabled
>> /sys/class/thermal/thermal_zone0/power/runtime_status:unsupported
>> /sys/class/thermal/thermal_zone0/power/runtime_usage:0
>> /sys/class/thermal/thermal_zone0/power/runtime_active_kids:0
>> /sys/class/thermal/thermal_zone0/power/runtime_enabled:disabled
>> /sys/class/thermal/thermal_zone0/power/control:auto
>> /sys/class/thermal/thermal_zone0/power/runtime_suspended_time:0
>> /sys/class/thermal/thermal_zone0/power/runtime_active_time:0
>> grep: /sys/class/thermal/thermal_zone0/power/autosuspend_delay_ms:
>> Input/output error
>> /sys/class/thermal/thermal_zone0/type:acpitz
>> /sys/class/thermal/thermal_zone0/temp:62000
>> /sys/class/thermal/thermal_zone0/mode:enabled
>> /sys/class/thermal/thermal_zone0/trip_point_0_type:critical
>> /sys/class/thermal/thermal_zone0/trip_point_0_temp:200000
>> /sys/class/thermal/thermal_zone0/trip_point_1_type:passive
>> /sys/class/thermal/thermal_zone0/trip_point_1_temp:90000
>> /sys/class/thermal/thermal_zone0/cdev0_trip_point:1
>> /sys/class/thermal/thermal_zone0/cdev1_trip_point:1
>> /sys/class/thermal/thermal_zone0/cdev2_trip_point:1
>> /sys/class/thermal/thermal_zone0/cdev3_trip_point:1
given that the 90° is a 'passive' trip_point it seems natural that the cdev[0-3]
linked to it, are apparently internal cpu cooling mechanisms rather than fans

$ grep -r . /sys/class/thermal/cool*
/sys/class/thermal/cooling_device0/power/async:disabled
/sys/class/thermal/cooling_device0/power/runtime_status:unsupported
/sys/class/thermal/cooling_device0/power/runtime_usage:0
/sys/class/thermal/cooling_device0/power/runtime_active_kids:0
/sys/class/thermal/cooling_device0/power/runtime_enabled:disabled
/sys/class/thermal/cooling_device0/power/control:auto
/sys/class/thermal/cooling_device0/power/runtime_suspended_time:0
/sys/class/thermal/cooling_device0/power/runtime_active_time:0
grep: /sys/class/thermal/cooling_device0/power/autosuspend_delay_ms: Input/output
error
/sys/class/thermal/cooling_device0/type:Processor
/sys/class/thermal/cooling_device0/max_state:10
/sys/class/thermal/cooling_device0/cur_state:0
/sys/class/thermal/cooling_device1/power/async:disabled
/sys/class/thermal/cooling_device1/power/runtime_status:unsupported
/sys/class/thermal/cooling_device1/power/runtime_usage:0
/sys/class/thermal/cooling_device1/power/runtime_active_kids:0
/sys/class/thermal/cooling_device1/power/runtime_enabled:disabled
/sys/class/thermal/cooling_device1/power/control:auto
/sys/class/thermal/cooling_device1/power/runtime_suspended_time:0
/sys/class/thermal/cooling_device1/power/runtime_active_time:0
grep: /sys/class/thermal/cooling_device1/power/autosuspend_delay_ms: Input/output
error
/sys/class/thermal/cooling_device1/type:Processor
/sys/class/thermal/cooling_device1/max_state:3
/sys/class/thermal/cooling_device1/cur_state:0
/sys/class/thermal/cooling_device2/power/async:disabled
/sys/class/thermal/cooling_device2/power/runtime_status:unsupported
/sys/class/thermal/cooling_device2/power/runtime_usage:0
/sys/class/thermal/cooling_device2/power/runtime_active_kids:0
/sys/class/thermal/cooling_device2/power/runtime_enabled:disabled
/sys/class/thermal/cooling_device2/power/control:auto
/sys/class/thermal/cooling_device2/power/runtime_suspended_time:0
/sys/class/thermal/cooling_device2/power/runtime_active_time:0
grep: /sys/class/thermal/cooling_device2/power/autosuspend_delay_ms: Input/output
error
/sys/class/thermal/cooling_device2/type:Processor
/sys/class/thermal/cooling_device2/max_state:3
/sys/class/thermal/cooling_device2/cur_state:0
/sys/class/thermal/cooling_device3/power/async:disabled
/sys/class/thermal/cooling_device3/power/runtime_status:unsupported
/sys/class/thermal/cooling_device3/power/runtime_usage:0
/sys/class/thermal/cooling_device3/power/runtime_active_kids:0
/sys/class/thermal/cooling_device3/power/runtime_enabled:disabled
/sys/class/thermal/cooling_device3/power/control:auto
/sys/class/thermal/cooling_device3/power/runtime_suspended_time:0
/sys/class/thermal/cooling_device3/power/runtime_active_time:0
grep: /sys/class/thermal/cooling_device3/power/autosuspend_delay_ms: Input/output
error
/sys/class/thermal/cooling_device3/type:Processor
/sys/class/thermal/cooling_device3/max_state:3
/sys/class/thermal/cooling_device3/cur_state:0
/sys/class/thermal/cooling_device4/power/async:disabled
/sys/class/thermal/cooling_device4/power/runtime_status:unsupported
/sys/class/thermal/cooling_device4/power/runtime_usage:0
/sys/class/thermal/cooling_device4/power/runtime_active_kids:0
/sys/class/thermal/cooling_device4/power/runtime_enabled:disabled
/sys/class/thermal/cooling_device4/power/control:auto
/sys/class/thermal/cooling_device4/power/runtime_suspended_time:0
/sys/class/thermal/cooling_device4/power/runtime_active_time:0
grep: /sys/class/thermal/cooling_device4/power/autosuspend_delay_ms: Input/output
error
/sys/class/thermal/cooling_device4/type:LCD
/sys/class/thermal/cooling_device4/max_state:9
/sys/class/thermal/cooling_device4/cur_state:0

surprising that the fan seems to work at all, given that there is no
kernel-registered cooling fan; yet it definitely goes faster the hotter the cpu
is, the trouble is that that is already too hot
> Regards,
> Clemens
thanks for allowing me to make some progress, seems I'll need to look more
carefully at the BIOS too; from my understanding of it Acer has non-pwm ways of
setting hardware registers to manage fan speed that'll be one angle to look into,
as long as they'll provide some documentation

hoping to avoid needing to compile custom kernels given that I've already emerged
bruised a few times from the myriad of compile options :)

Best regards

Mark
