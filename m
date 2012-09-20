Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab2ITHBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 03:01:07 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55259 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab2ITHBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 03:01:01 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <505ABF0B.5050909@jp.fujitsu.com>
Date: Thu, 20 Sep 2012 16:00:27 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>, Len Brown <lenb@kernel.org>
Subject: Re: PM: Summary of changes for v3.7
References: <201209182219.00649.rjw@sisk.pl> <50590D0C.5020206@jp.fujitsu.com> <201209191436.13526.rjw@sisk.pl>
In-Reply-To: <201209191436.13526.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

2012/09/19 21:36, Rafael J. Wysocki wrote:
> Hi,
>
> On Wednesday, September 19, 2012, Yasuaki Ishimatsu wrote:
>> Hi Rafael,
>>
>> I'd like to include following thread's patch into v3.7.
>>
>> https://patchwork.kernel.org/patch/1282121/
>>
>> The patch has been discussed and I have updated all comments.
>
> Well, the patch is not directly related to power management, so I can't take it
> (unless Len tells me that I can).
>
> I suppose Len has his own patch queue for v3.7 and your patch may be in that
> queue already.

Thank you for the reply. And sorry for my mistake of merge request.
I will confirm the current status of my patch to Len again.

Thanks,
Yasuaki Ishimatsu

> Thanks,
> Rafael
>
>
>> 2012/09/19 5:19, Rafael J. Wysocki wrote:
>>> Hi all,
>>>
>>> All of the changes I'd like to include into the first PM pull request during
>>> the v3.7 merge window, except maybe for a couple of patches I know of, but
>>> haven't decided what to do with them yet, is on the 'linux-next' branch of the
>>> linux-pm.git tree now.
>>>
>>> The summary of those changes is appended.  If anyone finds any of them
>>> objectionable, please let me know ASAP.  Also please let me know if there are
>>> any power management patches I've seen already that you'd like me to take for
>>> v3.7 (if I haven't seen them yet, they clearly are not v3.7 material, unless
>>> they are urgent fixes).
>>>
>>> Thanks,
>>> Rafael
>>>
>>> ---
>>>
>>>    Documentation/ABI/testing/sysfs-devices-system-cpu |  11 +
>>>    Documentation/cpu-freq/boost.txt                   |  93 +++++
>>>    Documentation/cpuidle/sysfs.txt                    |  10 +-
>>>    .../devicetree/bindings/cpufreq/cpufreq-cpu0.txt   |  55 +++
>>>    Documentation/devicetree/bindings/power/opp.txt    |  25 ++
>>>    arch/arm/kernel/smp.c                              |  54 +++
>>>    arch/arm/mach-shmobile/Makefile                    |   2 +-
>>>    arch/arm/mach-shmobile/board-ap4evb.c              |  21 +-
>>>    arch/arm/mach-shmobile/board-armadillo800eva.c     |   6 +-
>>>    arch/arm/mach-shmobile/board-mackerel.c            |  34 +-
>>>    arch/arm/mach-shmobile/common.c                    |  24 --
>>>    arch/arm/mach-shmobile/cpuidle.c                   |  39 +-
>>>    arch/arm/mach-shmobile/include/mach/common.h       |  14 +-
>>>    arch/arm/mach-shmobile/include/mach/pm-rmobile.h   |  35 +-
>>>    arch/arm/mach-shmobile/include/mach/r8a7740.h      |   6 +-
>>>    arch/arm/mach-shmobile/include/mach/r8a7779.h      |  12 +-
>>>    arch/arm/mach-shmobile/include/mach/sh7372.h       |  20 +-
>>>    arch/arm/mach-shmobile/pm-r8a7740.c                |  42 ++-
>>>    arch/arm/mach-shmobile/pm-r8a7779.c                |  71 ++--
>>>    arch/arm/mach-shmobile/pm-rmobile.c                |  33 +-
>>>    arch/arm/mach-shmobile/pm-sh7372.c                 | 283 ++++++++------
>>>    arch/arm/mach-shmobile/setup-r8a7740.c             |  27 +-
>>>    arch/arm/mach-shmobile/setup-r8a7779.c             |   5 +-
>>>    arch/arm/mach-shmobile/setup-sh7372.c              |  69 ++--
>>>    arch/x86/include/asm/msr-index.h                   |   3 +
>>>    drivers/acpi/processor_driver.c                    |   8 +-
>>>    drivers/acpi/processor_idle.c                      |  40 +-
>>>    drivers/acpi/processor_perflib.c                   |  30 ++
>>>    drivers/base/platform.c                            |   2 +
>>>    drivers/base/power/domain.c                        | 244 ++++++++++---
>>>    drivers/base/power/main.c                          |  35 +-
>>>    drivers/base/power/opp.c                           |  47 +++
>>>    drivers/base/power/power.h                         |  36 +-
>>>    drivers/base/power/wakeup.c                        |  46 ++-
>>>    drivers/clocksource/sh_cmt.c                       |  71 +++-
>>>    drivers/clocksource/sh_mtu2.c                      |  41 ++-
>>>    drivers/clocksource/sh_tmu.c                       | 112 +++++-
>>>    drivers/cpufreq/Kconfig                            |  11 +
>>>    drivers/cpufreq/Kconfig.x86                        |  18 +-
>>>    drivers/cpufreq/Makefile                           |   4 +-
>>>    drivers/cpufreq/acpi-cpufreq.c                     | 272 +++++++++++++-
>>>    drivers/cpufreq/cpufreq-cpu0.c                     | 269 ++++++++++++++
>>>    drivers/cpufreq/cpufreq_conservative.c             |   2 +
>>>    drivers/cpufreq/cpufreq_ondemand.c                 |   1 +
>>>    drivers/cpufreq/longhaul.h                         |  26 +-
>>>    drivers/cpufreq/omap-cpufreq.c                     |  35 --
>>>    drivers/cpufreq/powernow-k8.c                      | 406 ++-------------------
>>>    drivers/cpufreq/powernow-k8.h                      |  32 --
>>>    drivers/cpuidle/governors/ladder.c                 |   6 +-
>>>    drivers/xen/xen-acpi-processor.c                   |   1 -
>>>    include/acpi/processor.h                           |   9 +-
>>>    include/linux/clockchips.h                         |   8 +
>>>    include/linux/device.h                             |   7 +
>>>    include/linux/opp.h                                |   8 +
>>>    include/linux/pm.h                                 |   2 +
>>>    include/linux/pm_domain.h                          |  92 ++++-
>>>    kernel/power/Kconfig                               |   4 +
>>>    kernel/power/poweroff.c                            |   2 +-
>>>    kernel/power/process.c                             |   2 +-
>>>    kernel/power/qos.c                                 |   1 +
>>>    kernel/time/clockevents.c                          |  24 ++
>>>    kernel/time/timekeeping.c                          |   2 +
>>>    62 files changed, 2028 insertions(+), 922 deletions(-)
>>>
>>> ---------------
>>>
>>> Amit Daniel Kachhap (1):
>>>         PM / cpufreq: Initialise the cpu field during conservative governor start
>>>
>>> Andi Kleen (1):
>>>         sections: fix section conflicts in drivers/cpufreq
>>>
>>> Andre Przywara (5):
>>>         acpi-cpufreq: Add quirk to disable _PSD usage on all AMD CPUs
>>>         cpufreq: Add warning message to powernow-k8
>>>         powernow-k8: delay info messages until initialization has succeeded
>>>         acpi-cpufreq: Add support for disabling dynamic overclocking
>>>         acpi-cpufreq: Add compatibility for legacy AMD cpb sysfs knob
>>>
>>> Borislav Petkov (1):
>>>         cpufreq / powernow-k8: Fixup missing _PSS objects message
>>>
>>> Carsten Emde (1):
>>>         Honor state disabling in the cpuidle ladder governor
>>>
>>> Daniel Lezcano (4):
>>>         cpuidle / ACPI : remove power from acpi_processor_cx structure
>>>         ACPI / processor: remove unused function parameter
>>>         ACPI / processor: remove pointless variable initialization
>>>         cpuidle / ACPI : move cpuidle_device field out of the acpi_processor_power structure
>>>
>>> Jan Beulich (1):
>>>         properly __init-annotate pm_sysrq_init()
>>>
>>> John Stultz (1):
>>>         PM / wakeup: Use irqsave/irqrestore for events_lock
>>>
>>> Luis Gonzalez Fernandez (1):
>>>         PM / QoS: Add return code to pm_qos_get_value function.
>>>
>>> Matthew Garrett (3):
>>>         acpi-cpufreq: Add support for modern AMD CPUs
>>>         ACPI: Add fixups for AMD P-state figures
>>>         cpufreq: Remove support for hardware P-state chips from powernow-k8
>>>
>>> Michal Pecio (2):
>>>         cpufreq / ondemand: update frequency when limits are relaxed
>>>         cpufreq: conservative: update frequency when limits are relaxed
>>>
>>> Rafael J. Wysocki (40):
>>>         PM / cpuidle: Make ladder governor use the "disabled" state flag
>>>         PM / Domains: Introduce simplified power on routine for system resume
>>>         PM / Domains: Add power off/on function for system core suspend stage
>>>         timekeeping: Add suspend and resume of clock event devices
>>>         sh: TMU: Introduce clocksource/clock events suspend/resume routines
>>>         sh: CMT: Introduce clocksource/clock events suspend/resume routines
>>>         sh: MTU2: Introduce clock events suspend/resume routines
>>>         PM: Reorganize device PM initialization
>>>         PM / Runtime: Allow helpers to be called by early platform drivers
>>>         PM / Domains: Rename the always_on device flag to syscore
>>>         PM / Domains: Move syscore flag from subsys data to struct device
>>>         PM / Domains: Do not measure start time for "irq safe" devices
>>>         sh: TMU: Basic runtime PM support
>>>         sh: CMT: Basic runtime PM support
>>>         sh: MTU2: Basic runtime PM support
>>>         PM: Do not use the syscore flag for runtime PM
>>>         PM / Domains: Make it possible to use domain names when adding devices
>>>         PM / Domains: Make it possible to use names when adding subdomains
>>>         PM / Domains: Add power-on function using names to identify domains
>>>         PM / Domains: Document cpuidle-related functions and change their names
>>>         PM / Domains: Operations related to cpuidle using domain names
>>>         ARM: shmobile: Use names of power domains for adding devices to them
>>>         ARM: shmobile: Drop r8a7779_add_device_to_domain()
>>>         ARM: shmobile: Use domain names when adding subdomains to power domains
>>>         ARM: shmobile: Add routine for automatic PM domains initialization
>>>         ARM: shmobile: Do not access sh7372 A4S domain internals directly
>>>         ARM: shmobile: Move sh7372's PM domain objects to a table
>>>         ARM: shmobile: Move r8a7740's PM domain objects to a table
>>>         ARM: shmobile: Move r8a7779's PM domain objects to a table
>>>         ARM: shmobile: Make rmobile_init_pm_domain() static
>>>         ARM: shmobile: Set PM domain on/off latencies directly
>>>         ARM: shmobile: Allow device latencies to be specified directly
>>>         ARM: shmobile: Specify device latencies for SH7372 devices directly
>>>         ARM: shmobile: Specify device latencies for Mackerel devices directly
>>>         ARM: shmobile: Rework adding devices to PM domains on Mackerel
>>>         ARM: shmobile: Rework adding devices to PM domains on AP4EVB
>>>         ARM: shmobile: Remove the console check from sh7372_enter_suspend()
>>>         ARM: shmobile: Move definition of shmobile_init_late() to header
>>>         ARM: shmobile: Make sh7372 cpuidle handling more straightforward
>>>         ARM: shmobile: Add A4S cpuidle state on sh7372
>>>
>>> Richard Zhao (2):
>>>         ARM: add cpufreq transiton notifier to adjust loops_per_jiffy for smp
>>>         cpufreq: OMAP: remove loops_per_jiffy recalculate for smp
>>>
>>> Sachin Kamat (1):
>>>         PM / Domains: Fix compilation warning related to genpd_start_dev_no_timing()
>>>
>>> Sedat Dilek (1):
>>>         PM / Freezer: Fix small typo "regrigerator"
>>>
>>> Shawn Guo (2):
>>>         PM / OPP: Initialize OPP table from device tree
>>>         cpufreq: Add a generic cpufreq-cpu0 driver
>>>
>>> Todd Poynor (1):
>>>         PM / Sleep: Print name of wakeup source that aborts suspend
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
>>
>>
>


