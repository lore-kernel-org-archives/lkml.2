Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab2AQKea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 05:34:30 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:50505 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab2AQKe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 05:34:28 -0500
Message-ID: <4F154EAB.8080008@kernel.org>
Date: Tue, 17 Jan 2012 05:34:19 -0500
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110906 Fedora/3.1.14-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.14
MIME-Version: 1.0
To: =?UTF-8?B?QXJrYWRpdXN6IE1pxZtraWV3aWN6?= <a.miskiewicz@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: intel_idle causing 3.0.8 system reboot
References: <201110272327.14891.a.miskiewicz@gmail.com> <201110281954.39191.a.miskiewicz@gmail.com> <CAJvTdKmCgbebEOY7Ly=cE1ZV2GVG7hL5fE8LmK9nz7r8+BNPJQ@mail.gmail.com> <201111130854.56201.a.miskiewicz@gmail.com>
In-Reply-To: <201111130854.56201.a.miskiewicz@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2011 02:54 AM, Arkadiusz Miśkiewicz wrote:

> On Sunday 13 of November 2011, Len Brown wrote:
>>> intel_idle.max_cstate=2 also makes the problem go away.
>>
>> Is the system running with BIOS SETUP defaults?
> 
> Tried also with "safe defaults (F8)" but that didn't help.
> 
>> Are there any BIOS SETUP options related to CPU idle states?
> 
> Yes, there are
> 
> "C state package limit setting" with values possible: Auto, C1, C3, C6, C7 
> (set to "Auto" here)
> "Intel EIST technology" -> Enabled
> "C1E support" -> Enabled
> "Intel C-STATE tech" -> Enabled
> "C1 Auto Demotion" -> Enabled
> "C3 Auto Demotion" -> Enabled
> 
>> please boot with intel_idle.max_cstate=0
>> and send the output of these two commands:
>>
>> dmesg |grep idle
>> grep . /sys/devices/system/cpu/cpu0/cpuidle/*/*
> 
> [root@berta ~]# dmesg |grep idle
> [    0.000000] Command line: auto BOOT_IMAGE=pld3.0.8test ro root=812 
> console=tty0 console=ttyS2,38400n81 panic=60 selinux=0 intel_idle.max_cstate=0
> [    0.000000] Kernel command line: auto BOOT_IMAGE=pld3.0.8test ro root=812 
> console=tty0 console=ttyS2,38400n81 panic=60 selinux=0 intel_idle.max_cstate=0
> [    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
> [    0.278494] using mwait in idle threads.
> [    4.330321] intel_idle: disabled
> [    5.794456] cpuidle: using governor ladder
> [    5.806755] cpuidle: using governor menu
> [root@berta ~]# LC_ALL=C grep . /sys/devices/system/cpu/cpu0/cpuidle/*/*
> grep: /sys/devices/system/cpu/cpu0/cpuidle/*/*: No such file or directory
> 
> There are only:
> [root@berta ~]# LC_ALL=C grep . /sys/devices/system/cpu/cpuidle/*
> /sys/devices/system/cpu/cpuidle/current_driver:none
> /sys/devices/system/cpu/cpuidle/current_governor_ro:menu

very strange.
now that it is back up...
Please file a bug report at bugzilla.kernel.org against idle/intel_idle
and assign it to me.

Please attach the complete output from dmesg -s 64000
and attach your .config

It appears that you have no acpi_idle driver installed.

If your kernel is missing
CONFIG_ACPI_PROCESSOR=y
please add it and collect the info above.

thanks,
-Len



>>
>> thanks,
>> Len Brown, Intel Open Source Technology Center
>>
>>>> # cat /proc/cpuinfo
>>>> processor       : 0
>>>> vendor_id       : GenuineIntel
>>>> cpu family      : 6
>>>> model           : 30
>>>> model name      : Intel(R) Xeon(R) CPU           X3430  @ 2.40GHz
>>>> stepping        : 5
> 
> 


