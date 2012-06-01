Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab2FATb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 15:31:28 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34139 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755085Ab2FATb0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 15:31:26 -0400
MIME-Version: 1.0
Date: Fri, 1 Jun 2012 15:31:24 -0400
Message-ID: <CABAQT1ChtWVauLisaRk_KpN3JSWsvUXKKWDTAW6yuW-G32vmMw@mail.gmail.com>
Subject: =?UTF-8?Q?thermal=5Fzone_trip=5Fpoint=5F0=5Ftemp_200=C2=B0C?=
From: Mark B <markieb.lists.20090330@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Laptop overheating kernel 3.3.7.1 fedora 17, bizarre temp limit
readings; possibly k10temp module?

My Acer Aspire 5552-7260, AMD phenom II N970 cpu, is giving me very
bizarre temp limit readings; the main reason I'm noticing it is that
it is heating up to 70° without much of a load, 63° at startup under
virtually no load; works well in windows, 48° as equivalent to the
linux 63°, so my gradual conclusion is that it's some kernel-level
code that needs changing?

Can't fancontrol/pwmconfig as apparently — from my limited knowledge
of how to double-check, I've tried looking in all the relevant /sys
nodes — there are no pwm-capable fans; lm_sensors, however, gives the
200°C temp limit as does acpiclient; I'm noticing that there are some
kernel patches affecting the area, although it is unclear to me how
far that would even make it the kernel's responsibility; I've tried
all the acpi_osi=Linux, acpi_osi="Linux", acpi_osi=\\\"Linux\\\",
acpi_enforce_resources=lax, acpi.power_nocheck=1 alternatives without
sign of change; as I recalled from my eeepc that that was the way of
preventing the newer, non-fully-functional, acpi kernel module, from
loading, forcing legacy acpi/pwm support; in fact the overheating
eeepc is one more reason I'm writing to the kernel list now, as I'm
seeing a kind of pattern of computers overheating in linux when in
principle all that it should need would be faster fan speeds / lower
soft limits;

Looking carefully at the modules list, I see k10temp as the most
obvious sensor module, unsure how relevant that is

my understanding of it is that the Kernel/the Bios manages the fan
speed in 'automatic' mode, as distinguished from fancontrol-type
'manual' mode; given that windows manages it properly, I'd have to
conclude it wouldn't normally be the Bios's fault?

$ cat /proc/version
Linux version 3.3.7-1.fc17.x86_64
(mockbuild@x86-11.phx2.fedoraproject.org) (gcc version 4.7.0 20120507
(Red Hat 4.7.0-5) (GCC) ) #1 SMP Mon May 21 22:32:19 UTC 2012

$ cat /proc/cpuinfo
processor : 0
vendor_id : AuthenticAMD
cpu family : 16
model : 5
model name : AMD Phenom(tm) II N970 Quad-Core Processor
stepping : 3
microcode : 0x10000c8
cpu MHz : 800.000
cache size : 512 KB
physical id : 0
siblings : 4
core id : 0
cpu cores : 4
apicid : 0
initial apicid : 0
fpu : yes
fpu_exception : yes
cpuid level : 5
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl
nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit
wdt nodeid_msr npt lbrv svm_lock nrip_save
bogomips : 4388.95
TLB size : 1024 4K pages
clflush size : 64
cache_alignment : 64
address sizes : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate
[etc]

$ grep -r . /sys/class/thermal/thermal_zone*
/sys/class/thermal/thermal_zone0/power/async:disabled
/sys/class/thermal/thermal_zone0/power/runtime_status:unsupported
/sys/class/thermal/thermal_zone0/power/runtime_usage:0
/sys/class/thermal/thermal_zone0/power/runtime_active_kids:0
/sys/class/thermal/thermal_zone0/power/runtime_enabled:disabled
/sys/class/thermal/thermal_zone0/power/control:auto
/sys/class/thermal/thermal_zone0/power/runtime_suspended_time:0
/sys/class/thermal/thermal_zone0/power/runtime_active_time:0
grep: /sys/class/thermal/thermal_zone0/power/autosuspend_delay_ms:
Input/output error
/sys/class/thermal/thermal_zone0/type:acpitz
/sys/class/thermal/thermal_zone0/temp:62000
/sys/class/thermal/thermal_zone0/mode:enabled
/sys/class/thermal/thermal_zone0/trip_point_0_type:critical
/sys/class/thermal/thermal_zone0/trip_point_0_temp:200000
/sys/class/thermal/thermal_zone0/trip_point_1_type:passive
/sys/class/thermal/thermal_zone0/trip_point_1_temp:90000
/sys/class/thermal/thermal_zone0/cdev0_trip_point:1
/sys/class/thermal/thermal_zone0/cdev1_trip_point:1
/sys/class/thermal/thermal_zone0/cdev2_trip_point:1
/sys/class/thermal/thermal_zone0/cdev3_trip_point:1


$ sh ~/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux MYCOMPUTER 3.3.7-1.fc17.x86_64 #1 SMP Mon May 21 22:32:19 UTC
2012 x86_64 x86_64 x86_64 GNU/Linux

Gnu C                  4.7.0
Gnu make               3.82
binutils               2.22.52.0.1
util-linux             2.21.2
mount                  debug
module-init-tools      7
e2fsprogs              1.42
xfsprogs               3.1.8
pcmciautils            018
PPP                    2.4.5
Linux C Library        2.15
Dynamic linker (ldd)   2.15
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15.3wip
Sh-utils               8.15
wireless-tools         29
Modules Loaded         ip6table_filter ip6_tables ip6t_REJECT
nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack fuse bnep bluetooth uvcvideo videobuf2_vmalloc
videobuf2_memops videobuf2_core videodev media snd_hda_codec_hdmi arc4
broadcom snd_hda_codec_realtek ath9k ath9k_common ath9k_hw ath
mac80211 cfg80211 snd_hda_intel snd_hda_codec tg3 acer_wmi
sparse_keymap snd_hwdep snd_pcm rfkill snd_page_alloc shpchp
sp5100_tco edac_core edac_mce_amd snd_timer snd k10temp microcode
soundcore i2c_piix4 uinput ums_realtek usb_storage video wmi radeon
i2c_algo_bit drm_kms_helper ttm drm i2c_core

I'll be happy to provide the results from

dmesg | grep -i acpi
lspci -vvv

etc should you need it

please cc me directly when responding

thanks for reading

Best regards

Mark
