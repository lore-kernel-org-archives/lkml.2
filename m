Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab2LJG71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 01:59:27 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:56695 "EHLO
	95-31-19-74.broadband.corbina.ru" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752412Ab2LJG7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 01:59:24 -0500
Message-ID: <50C58846.7000408@ilyx.ru>
Date: Mon, 10 Dec 2012 10:59:18 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [BUG -next] cpufreq: cpufreq_governor.
References: <50BF9480.20400@ilyx.ru> <50BF9824.7070903@ilyx.ru> <50C4C790.4080206@ilyx.ru> <1619333.jM1smpk2m8@vostro.rjw.lan>
In-Reply-To: <1619333.jM1smpk2m8@vostro.rjw.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.12.2012 3:08, Rafael J. Wysocki wrote:
> On Sunday, December 09, 2012 09:17:04 PM Ilya Zykov wrote:
>> On 05.12.2012 22:53, Ilya Zykov wrote:
>>> What do I do wrong?
>>>
>>> After: modprobe cpufreq_ondemand
>>> I have:
>>>
>>> WARNING: Error inserting freq_table (/lib/modules/3.7.0-rc8-next-20121205-ttybuf.1+/kernel/drivers/cpufreq/freq_table.ko): Unknown symbol in module, or unknown parameter (see dmesg)
>>> FATAL: Error inserting cpufreq_ondemand (/lib/modules/3.7.0-rc8-next-20121205-ttybuf.1+/kernel/drivers/cpufreq/cpufreq_ondemand.ko): Unknown symbol in module, or unknown parameter (see dmesg)
>>>
>>> dmesg:
>>> Dec  5 22:26:11 bm kernel: cpufreq_governor: Unknown symbol __cpufreq_driver_getavg (err 0)
>>> Dec  5 22:26:11 bm kernel: cpufreq_governor: Unknown symbol sysfs_create_group (err 0)
>>> Dec  5 22:26:11 bm kernel: cpufreq_governor: Unknown symbol sysfs_remove_group (err 0)
>>> Dec  5 22:26:11 bm kernel: cpufreq_governor: Unknown symbol __cpufreq_driver_target (err 0)
>>> Dec  5 22:26:11 bm kernel: cpufreq_governor: Unknown symbol get_cpu_idle_time_us (err 0)
>>> Dec  5 22:26:11 bm kernel: cpufreq_governor: Unknown symbol delayed_work_timer_fn (err 0)
>>> Dec  5 22:26:11 bm kernel: cpufreq_governor: Unknown symbol get_cpu_iowait_time_us (err 0)
>>>
>>> cat /proc/kallsyms |grep freq_dr
>>> ffffffff814976e0 T __cpufreq_driver_target
>>> ffffffff814987e0 T __cpufreq_driver_getavg
>>> ffffffff81498850 T cpufreq_driver_target
>>> ffffffff81881650 r __ksymtab___cpufreq_driver_getavg
>>> ffffffff81881660 r __ksymtab___cpufreq_driver_target
>>> ffffffff81883b40 r __ksymtab_cpufreq_driver_target
>>> ffffffff81894290 r __kcrctab___cpufreq_driver_getavg
>>> ffffffff81894298 r __kcrctab___cpufreq_driver_target
>>> ffffffff81895508 r __kcrctab_cpufreq_driver_target
>>> ffffffff818b3080 r __kstrtab___cpufreq_driver_getavg
>>> ffffffff818b3098 r __kstrtab_cpufreq_driver_target
>>> ffffffff818b30ae r __kstrtab___cpufreq_driver_target
>>> ffffffff81e240c8 b cpufreq_driver_lock
>>> ffffffff81e240d0 b cpufreq_driver
>>> ffffffffa0c42000 d acpi_cpufreq_driver	[acpi_cpufreq]
>>
>> I managed to fix:
>>
>> git checkout 16642a2e7be23bb -- drivers/cpufreq
>> git checkout 250f6715a4112d668 -- include/linux/cpufreq.h
> 
> Can you please send your .config?
> 
> Rafael
> 
> 

gcc --version
gcc (GCC) 4.4.6 20120305 (Red Hat 4.4.6-4)
Copyright (C) 2010 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


