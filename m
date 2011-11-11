Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957Ab1KKQCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 11:02:00 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35412 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226Ab1KKQB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 11:01:57 -0500
Message-ID: <4EBD46DF.6060507@gmail.com>
Date: Fri, 11 Nov 2011 13:01:35 -0300
From: "Tomas M." <tmezzadra@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111108 Thunderbird/8.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: deepthi@linux.vnet.ibm.com, g.trinabh@gmail.com, j-pihet@ti.com,
        khilman@ti.com, arjan@linux.intel.com, len.brown@intel.com
Subject: [bisected][bug] commit e978aa7d7d57d04eb5f88 breaks suspend on laptop.
Content-Type: multipart/mixed;
 boundary="------------040906030300080106060700"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040906030300080106060700
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

bisected to e978aa7d7d57d04eb5f88a7507c4fb98577def77

cannot revert the commit cleanly to further test

attaching pm-suspend log.  /proc/cpuinfo and lspci -vvnn just in case. 
If more info is needed, please let me know.

thanks!
----
when trying to suspend... the system locks right before suspending.
sysrq keys  will not work at this point


please include me in the CC since im not subscribed to the list.

i CCed everyone mentioned in the commit. if you were CCed by mystake, sorry.


--------------040906030300080106060700
Content-Type: text/plain;
 name="bisect_log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="bisect_log"

git bisect start
# good: [c3b92c8787367a8bb53d57d9789b558f1295cc96] Linux 3.1
git bisect good c3b92c8787367a8bb53d57d9789b558f1295cc96
# bad: [1ea6b8f48918282bdca0b32a34095504ee65bab5] Linux 3.2-rc1
git bisect bad 1ea6b8f48918282bdca0b32a34095504ee65bab5
# good: [37be944a0270402f9cda291a930b0286f6dc92f5] Merge branch 'drm-core-next' of git://people.freedesktop.org/~airlied/linux
git bisect good 37be944a0270402f9cda291a930b0286f6dc92f5
# good: [68e24ba70465b82ad24e0774ceab5360180d4627] Merge branch 'next/fixes' of git://git.linaro.org/people/arnd/arm-soc
git bisect good 68e24ba70465b82ad24e0774ceab5360180d4627
# good: [f9c4082df59e43c6667db197a4fb3eb3286f3fc1] forcedeth: fix race when unloading module
git bisect good f9c4082df59e43c6667db197a4fb3eb3286f3fc1
# good: [208bca0860406d16398145ddd950036a737c3c9d] Merge branch 'writeback-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux
git bisect good 208bca0860406d16398145ddd950036a737c3c9d
# good: [403299a8515c56db58454c57712f4dc96d6c1fde] Merge branch 'upstream/xen-settime' of git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen
git bisect good 403299a8515c56db58454c57712f4dc96d6c1fde
# good: [157550ff77cb5087033382782f4e856094466c16] mtd: add GPMI-NAND driver in the config and Makefile
git bisect good 157550ff77cb5087033382782f4e856094466c16
# good: [83dbb15e9cd78a3619e3db36777e2f81d09b2914] Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux
git bisect good 83dbb15e9cd78a3619e3db36777e2f81d09b2914
# bad: [54a0f91301950af3d6ae2ff2bf710c9c68a9bfea] Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad 54a0f91301950af3d6ae2ff2bf710c9c68a9bfea
# bad: [50e696308c3fb18a4a0dae7b3a4d47469149c919] vfs: d_invalidate() should leave mountpoints alone
git bisect bad 50e696308c3fb18a4a0dae7b3a4d47469149c919
# good: [e751b759e82629798c4a5e4a87eb3a30c0510154] Merge branches 'atomic-io', 'lockdep', 'misc', 'pm-profile' and 'pnp-cleanup' into acpi
git bisect good e751b759e82629798c4a5e4a87eb3a30c0510154
# bad: [efb90582c575084723cc14302c1300cb26c7e01f] Merge branches 'acpi', 'idle', 'mrst-pmu' and 'pm-tools' into next
git bisect bad efb90582c575084723cc14302c1300cb26c7e01f
# bad: [4202735e8ab6ecfb0381631a0d0b58fefe0bd4e2] cpuidle: Split cpuidle_state structure and move per-cpu statistics fields
git bisect bad 4202735e8ab6ecfb0381631a0d0b58fefe0bd4e2
# bad: [b25edc42bfb9602f0503474b2c94701d5536ce60] cpuidle: Remove CPUIDLE_FLAG_IGNORE and dev->prepare()
git bisect bad b25edc42bfb9602f0503474b2c94701d5536ce60
# bad: [e978aa7d7d57d04eb5f88a7507c4fb98577def77] cpuidle: Move dev->last_residency update to driver enter routine; remove dev->last_state
git bisect bad e978aa7d7d57d04eb5f88a7507c4fb98577def77

--------------040906030300080106060700
Content-Type: text/plain;
 name="cpuinfo"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cpuinfo"

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 14
model name	: Genuine Intel(R) CPU           T2080  @ 1.73GHz
stepping	: 12
cpu MHz		: 100.000
cache size	: 1024 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx constant_tsc arch_perfmon bts aperfmperf pni monitor est tm2 xtpr pdcm dts
bogomips	: 3457.91
clflush size	: 64
cache_alignment	: 64
address sizes	: 32 bits physical, 32 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 14
model name	: Genuine Intel(R) CPU           T2080  @ 1.73GHz
stepping	: 12
cpu MHz		: 100.000
cache size	: 1024 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx constant_tsc arch_perfmon bts aperfmperf pni monitor est tm2 xtpr pdcm dts
bogomips	: 3457.87
clflush size	: 64
cache_alignment	: 64
address sizes	: 32 bits physical, 32 bits virtual
power management:


--------------040906030300080106060700
Content-Type: text/x-log;
 name="pm-suspend.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="pm-suspend.log"

enabled, not active

/usr/lib/pm-utils/sleep.d/01laptop-mode resume suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/01grub resume suspend:

/usr/lib/pm-utils/sleep.d/01grub resume suspend: success.
Running hook /etc/pm/sleep.d/00savings resume suspend:

/etc/pm/sleep.d/00savings resume suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/00powersave resume suspend:

/usr/lib/pm-utils/sleep.d/00powersave resume suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/00logging resume suspend:

/usr/lib/pm-utils/sleep.d/00logging resume suspend: success.
Thu Nov 10 23:23:50 ART 2011: Finished.
Initial commandline parameters: 
Thu Nov 10 23:29:55 ART 2011: Running hooks for suspend.
Running hook /usr/lib/pm-utils/sleep.d/00logging suspend suspend:
Linux lappy 3.1.0-GIT-00016-gefb9058 #85 SMP PREEMPT Thu Nov 10 18:20:06 ART 2011 i686 Genuine Intel(R) CPU T2080 @ 1.73GHz GenuineIntel GNU/Linux
Module                  Size  Used by
arc4                    1046  2 
rt73usb                22037  0 
rt2x00usb               7360  1 rt73usb
rt2x00lib              29342  2 rt73usb,rt2x00usb
mac80211              191468  2 rt2x00usb,rt2x00lib
cfg80211              138015  2 rt2x00lib,mac80211
usbhid                 30427  0 
hid                    64415  1 usbhid
rfkill                 11694  1 cfg80211
joydev                  7247  0 
snd_hda_codec_si3054     2730  1 
psmouse                47369  0 
snd_hda_codec_realtek   206949  1 
iTCO_wdt                9773  0 
iTCO_vendor_support     1409  1 iTCO_wdt
snd_hda_intel          18877  2 
snd_hda_codec          64501  3 snd_hda_codec_si3054,snd_hda_codec_realtek,snd_hda_intel
snd_hwdep               4710  1 snd_hda_codec
snd_pcm                57991  3 snd_hda_codec_si3054,snd_hda_intel,snd_hda_codec
snd_timer              14823  1 snd_pcm
snd                    41065  11 snd_hda_codec_si3054,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer
i2c_i801                7025  0 
serio_raw               3222  0 
firewire_ohci          25520  0 
firewire_core          42427  1 firewire_ohci
evdev                   7182  10 
soundcore               4378  1 snd
crc_itu_t                997  2 rt73usb,firewire_core
snd_page_alloc          5477  2 snd_hda_intel,snd_pcm
ac                      2305  0 
battery                 8317  0 
thermal                 6107  0 
cpufreq_ondemand        4952  2 
acpi_cpufreq            5009  1 
freq_table              1943  2 cpufreq_ondemand,acpi_cpufreq
processor              22094  3 acpi_cpufreq
mperf                    955  1 acpi_cpufreq
ext3                  107237  2 
jbd                    39217  1 ext3
mbcache                 4081  1 ext3
sd_mod                 25691  4 
sr_mod                 13212  0 
cdrom                  31823  1 sr_mod
pata_acpi               2252  0 
uhci_hcd               19345  0 
ata_piix               18233  3 
libata                141765  2 pata_acpi,ata_piix
scsi_mod               81238  3 sd_mod,sr_mod,libata
ehci_hcd               35301  0 
usbcore               116190  6 rt73usb,rt2x00usb,usbhid,uhci_hcd,ehci_hcd
             total       used       free     shared    buffers     cached
Mem:       2065988     471764    1594224          0       7448     403776
-/+ buffers/cache:      60540    2005448
Swap:      3004116          0    3004116

/usr/lib/pm-utils/sleep.d/00logging suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/00powersave suspend suspend:

/usr/lib/pm-utils/sleep.d/00powersave suspend suspend: success.
Running hook /etc/pm/sleep.d/00savings suspend suspend:

/etc/pm/sleep.d/00savings suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/01grub suspend suspend:

/usr/lib/pm-utils/sleep.d/01grub suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/01laptop-mode suspend suspend:

/usr/lib/pm-utils/sleep.d/01laptop-mode suspend suspend: success.
Running hook /etc/pm/sleep.d/11netcfg suspend suspend:

/etc/pm/sleep.d/11netcfg suspend suspend: success.
Running hook /etc/pm/sleep.d/12modules suspend suspend:

/etc/pm/sleep.d/12modules suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/49bluetooth suspend suspend:

/usr/lib/pm-utils/sleep.d/49bluetooth suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/75modules suspend suspend:

/usr/lib/pm-utils/sleep.d/75modules suspend suspend: success.
Running hook /etc/pm/sleep.d/90alsa suspend suspend:

/etc/pm/sleep.d/90alsa suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/90clock suspend suspend:

/usr/lib/pm-utils/sleep.d/90clock suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/94cpufreq suspend suspend:

/usr/lib/pm-utils/sleep.d/94cpufreq suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/95led suspend suspend:

/usr/lib/pm-utils/sleep.d/95led suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/98video-quirk-db-handler suspend suspend:
Kernel modesetting video driver detected, not using quirks.

/usr/lib/pm-utils/sleep.d/98video-quirk-db-handler suspend suspend: success.
Running hook /etc/pm/sleep.d/999sync suspend suspend:

/etc/pm/sleep.d/999sync suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/99video suspend suspend:
kernel.acpi_video_flags = 0

/usr/lib/pm-utils/sleep.d/99video suspend suspend: success.
Thu Nov 10 23:29:56 ART 2011: performing suspend
Initial commandline parameters: 
Thu Nov 10 23:48:28 ART 2011: Running hooks for suspend.
Running hook /usr/lib/pm-utils/sleep.d/00logging suspend suspend:
Linux lappy 3.1.0-GIT-00003-g4202735 #86 SMP PREEMPT Thu Nov 10 23:39:52 ART 2011 i686 Genuine Intel(R) CPU T2080 @ 1.73GHz GenuineIntel GNU/Linux
Module                  Size  Used by
arc4                    1046  2 
rt73usb                22037  0 
rt2x00usb               7360  1 rt73usb
rt2x00lib              29342  2 rt73usb,rt2x00usb
mac80211              191468  2 rt2x00usb,rt2x00lib
cfg80211              138015  2 rt2x00lib,mac80211
usbhid                 30427  0 
hid                    64415  1 usbhid
rfkill                 11694  1 cfg80211
joydev                  7247  0 
snd_hda_codec_si3054     2730  1 
snd_hda_codec_realtek   206949  1 
snd_hda_intel          18877  2 
snd_hda_codec          64501  3 snd_hda_codec_si3054,snd_hda_codec_realtek,snd_hda_intel
snd_hwdep               4710  1 snd_hda_codec
snd_pcm                57991  3 snd_hda_codec_si3054,snd_hda_intel,snd_hda_codec
snd_timer              14823  1 snd_pcm
snd                    41065  11 snd_hda_codec_si3054,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer
iTCO_wdt                9773  0 
iTCO_vendor_support     1409  1 iTCO_wdt
i2c_i801                7025  0 
firewire_ohci          25520  0 
evdev                   7182  10 
psmouse                47369  0 
serio_raw               3222  0 
firewire_core          42427  1 firewire_ohci
battery                 8317  0 
thermal                 6107  0 
crc_itu_t                997  2 rt73usb,firewire_core
soundcore               4378  1 snd
snd_page_alloc          5477  2 snd_hda_intel,snd_pcm
ac                      2305  0 
cpufreq_ondemand        4952  2 
acpi_cpufreq            5009  1 
freq_table              1943  2 cpufreq_ondemand,acpi_cpufreq
processor              20908  3 acpi_cpufreq
mperf                    955  1 acpi_cpufreq
ext3                  107237  2 
jbd                    39217  1 ext3
mbcache                 4081  1 ext3
sr_mod                 13212  0 
sd_mod                 25691  4 
cdrom                  31823  1 sr_mod
pata_acpi               2252  0 
uhci_hcd               19345  0 
ata_piix               18233  3 
libata                141765  2 pata_acpi,ata_piix
scsi_mod               81238  3 sr_mod,sd_mod,libata
ehci_hcd               35301  0 
usbcore               116190  6 rt73usb,rt2x00usb,usbhid,uhci_hcd,ehci_hcd
             total       used       free     shared    buffers     cached
Mem:       2065988     472468    1593520          0       7436     404640
-/+ buffers/cache:      60392    2005596
Swap:      3004116          0    3004116

/usr/lib/pm-utils/sleep.d/00logging suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/00powersave suspend suspend:

/usr/lib/pm-utils/sleep.d/00powersave suspend suspend: success.
Running hook /etc/pm/sleep.d/00savings suspend suspend:

/etc/pm/sleep.d/00savings suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/01grub suspend suspend:

/usr/lib/pm-utils/sleep.d/01grub suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/01laptop-mode suspend suspend:

/usr/lib/pm-utils/sleep.d/01laptop-mode suspend suspend: success.
Running hook /etc/pm/sleep.d/11netcfg suspend suspend:

/etc/pm/sleep.d/11netcfg suspend suspend: success.
Running hook /etc/pm/sleep.d/12modules suspend suspend:

/etc/pm/sleep.d/12modules suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/49bluetooth suspend suspend:

/usr/lib/pm-utils/sleep.d/49bluetooth suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/75modules suspend suspend:

/usr/lib/pm-utils/sleep.d/75modules suspend suspend: success.
Running hook /etc/pm/sleep.d/90alsa suspend suspend:

/etc/pm/sleep.d/90alsa suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/90clock suspend suspend:

/usr/lib/pm-utils/sleep.d/90clock suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/94cpufreq suspend suspend:

/usr/lib/pm-utils/sleep.d/94cpufreq suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/95led suspend suspend:

/usr/lib/pm-utils/sleep.d/95led suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/98video-quirk-db-handler suspend suspend:
Kernel modesetting video driver detected, not using quirks.

/usr/lib/pm-utils/sleep.d/98video-quirk-db-handler suspend suspend: success.
Running hook /etc/pm/sleep.d/999sync suspend suspend:

/etc/pm/sleep.d/999sync suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/99video suspend suspend:
kernel.acpi_video_flags = 0

/usr/lib/pm-utils/sleep.d/99video suspend suspend: success.
Thu Nov 10 23:48:29 ART 2011: performing suspend
Initial commandline parameters: 
Fri Nov 11 12:15:43 ART 2011: Running hooks for suspend.
Running hook /usr/lib/pm-utils/sleep.d/00logging suspend suspend:
Linux lappy 3.1.0-GIT-00002-gb25edc4 #87 SMP PREEMPT Thu Nov 10 23:54:52 ART 2011 i686 Genuine Intel(R) CPU T2080 @ 1.73GHz GenuineIntel GNU/Linux
Module                  Size  Used by
arc4                    1046  2 
rt73usb                22037  0 
rt2x00usb               7360  1 rt73usb
rt2x00lib              29342  2 rt73usb,rt2x00usb
mac80211              191468  2 rt2x00usb,rt2x00lib
cfg80211              138015  2 rt2x00lib,mac80211
rfkill                 11694  1 cfg80211
joydev                  7247  0 
snd_hda_codec_si3054     2730  1 
snd_hda_codec_realtek   206949  1 
snd_hda_intel          18877  2 
snd_hda_codec          64501  3 snd_hda_codec_si3054,snd_hda_codec_realtek,snd_hda_intel
snd_hwdep               4710  1 snd_hda_codec
snd_pcm                57991  3 snd_hda_codec_si3054,snd_hda_intel,snd_hda_codec
snd_timer              14823  1 snd_pcm
snd                    41065  11 snd_hda_codec_si3054,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer
psmouse                47369  0 
serio_raw               3222  0 
firewire_ohci          25520  0 
firewire_core          42427  1 firewire_ohci
soundcore               4378  1 snd
crc_itu_t                997  2 rt73usb,firewire_core
snd_page_alloc          5477  2 snd_hda_intel,snd_pcm
iTCO_wdt                9773  0 
iTCO_vendor_support     1409  1 iTCO_wdt
i2c_i801                7025  0 
thermal                 6107  0 
ac                      2305  0 
battery                 8317  0 
evdev                   7182  7 
cpufreq_ondemand        4952  2 
acpi_cpufreq            5009  1 
freq_table              1943  2 cpufreq_ondemand,acpi_cpufreq
processor              20876  3 acpi_cpufreq
mperf                    955  1 acpi_cpufreq
ext3                  107237  2 
jbd                    39217  1 ext3
mbcache                 4081  1 ext3
sd_mod                 25691  4 
sr_mod                 13212  0 
cdrom                  31823  1 sr_mod
pata_acpi               2252  0 
uhci_hcd               19345  0 
ata_piix               18233  3 
libata                141765  2 pata_acpi,ata_piix
ehci_hcd               35301  0 
scsi_mod               81238  3 sd_mod,sr_mod,libata
usbcore               116190  5 rt73usb,rt2x00usb,uhci_hcd,ehci_hcd
             total       used       free     shared    buffers     cached
Mem:       2065988     505696    1560292          0       7940     428556
-/+ buffers/cache:      69200    1996788
Swap:      3004116          0    3004116

/usr/lib/pm-utils/sleep.d/00logging suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/00powersave suspend suspend:

/usr/lib/pm-utils/sleep.d/00powersave suspend suspend: success.
Running hook /etc/pm/sleep.d/00savings suspend suspend:

/etc/pm/sleep.d/00savings suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/01grub suspend suspend:

/usr/lib/pm-utils/sleep.d/01grub suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/01laptop-mode suspend suspend:

/usr/lib/pm-utils/sleep.d/01laptop-mode suspend suspend: success.
Running hook /etc/pm/sleep.d/11netcfg suspend suspend:

/etc/pm/sleep.d/11netcfg suspend suspend: success.
Running hook /etc/pm/sleep.d/12modules suspend suspend:

/etc/pm/sleep.d/12modules suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/49bluetooth suspend suspend:

/usr/lib/pm-utils/sleep.d/49bluetooth suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/75modules suspend suspend:

/usr/lib/pm-utils/sleep.d/75modules suspend suspend: success.
Running hook /etc/pm/sleep.d/90alsa suspend suspend:

/etc/pm/sleep.d/90alsa suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/90clock suspend suspend:

/usr/lib/pm-utils/sleep.d/90clock suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/94cpufreq suspend suspend:

/usr/lib/pm-utils/sleep.d/94cpufreq suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/95led suspend suspend:

/usr/lib/pm-utils/sleep.d/95led suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/98video-quirk-db-handler suspend suspend:
Kernel modesetting video driver detected, not using quirks.

/usr/lib/pm-utils/sleep.d/98video-quirk-db-handler suspend suspend: success.
Running hook /etc/pm/sleep.d/999sync suspend suspend:

/etc/pm/sleep.d/999sync suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/99video suspend suspend:
kernel.acpi_video_flags = 0

/usr/lib/pm-utils/sleep.d/99video suspend suspend: success.
Fri Nov 11 12:15:44 ART 2011: performing suspend
Initial commandline parameters: 
Fri Nov 11 12:40:52 ART 2011: Running hooks for suspend.
Running hook /usr/lib/pm-utils/sleep.d/00logging suspend suspend:
Linux lappy 3.1.0-GIT-00001-ge978aa7 #88 SMP PREEMPT Fri Nov 11 12:24:49 ART 2011 i686 Genuine Intel(R) CPU T2080 @ 1.73GHz GenuineIntel GNU/Linux
Module                  Size  Used by
arc4                    1046  2 
rt73usb                22037  0 
rt2x00usb               7360  1 rt73usb
rt2x00lib              29342  2 rt73usb,rt2x00usb
mac80211              191468  2 rt2x00usb,rt2x00lib
cfg80211              138015  2 rt2x00lib,mac80211
rfkill                 11694  1 cfg80211
usbhid                 30427  0 
hid                    64415  1 usbhid
joydev                  7247  0 
firewire_ohci          25520  0 
firewire_core          42427  1 firewire_ohci
crc_itu_t                997  2 rt73usb,firewire_core
snd_hda_codec_si3054     2730  1 
snd_hda_codec_realtek   206949  1 
snd_hda_intel          18877  2 
snd_hda_codec          64501  3 snd_hda_codec_si3054,snd_hda_codec_realtek,snd_hda_intel
snd_hwdep               4710  1 snd_hda_codec
snd_pcm                57991  3 snd_hda_codec_si3054,snd_hda_intel,snd_hda_codec
snd_timer              14823  1 snd_pcm
snd                    41065  11 snd_hda_codec_si3054,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer
soundcore               4378  1 snd
psmouse                47369  0 
iTCO_wdt                9773  0 
iTCO_vendor_support     1409  1 iTCO_wdt
serio_raw               3222  0 
i2c_i801                7025  0 
evdev                   7182  10 
snd_page_alloc          5477  2 snd_hda_intel,snd_pcm
ac                      2305  0 
battery                 8317  0 
thermal                 6107  0 
cpufreq_ondemand        4952  2 
acpi_cpufreq            5009  1 
freq_table              1943  2 cpufreq_ondemand,acpi_cpufreq
processor              20876  3 acpi_cpufreq
mperf                    955  1 acpi_cpufreq
ext3                  107237  2 
jbd                    39217  1 ext3
mbcache                 4081  1 ext3
sr_mod                 13212  0 
sd_mod                 25691  4 
cdrom                  31823  1 sr_mod
pata_acpi               2252  0 
uhci_hcd               19345  0 
ata_piix               18233  3 
libata                141765  2 pata_acpi,ata_piix
ehci_hcd               35301  0 
scsi_mod               81238  3 sr_mod,sd_mod,libata
usbcore               116190  6 rt73usb,rt2x00usb,usbhid,uhci_hcd,ehci_hcd
             total       used       free     shared    buffers     cached
Mem:       2065988     471516    1594472          0       7472     402988
-/+ buffers/cache:      61056    2004932
Swap:      3004116          0    3004116

/usr/lib/pm-utils/sleep.d/00logging suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/00powersave suspend suspend:

/usr/lib/pm-utils/sleep.d/00powersave suspend suspend: success.
Running hook /etc/pm/sleep.d/00savings suspend suspend:

/etc/pm/sleep.d/00savings suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/01grub suspend suspend:

/usr/lib/pm-utils/sleep.d/01grub suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/01laptop-mode suspend suspend:

/usr/lib/pm-utils/sleep.d/01laptop-mode suspend suspend: success.
Running hook /etc/pm/sleep.d/11netcfg suspend suspend:

/etc/pm/sleep.d/11netcfg suspend suspend: success.
Running hook /etc/pm/sleep.d/12modules suspend suspend:

/etc/pm/sleep.d/12modules suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/49bluetooth suspend suspend:

/usr/lib/pm-utils/sleep.d/49bluetooth suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/75modules suspend suspend:

/usr/lib/pm-utils/sleep.d/75modules suspend suspend: success.
Running hook /etc/pm/sleep.d/90alsa suspend suspend:

/etc/pm/sleep.d/90alsa suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/90clock suspend suspend:

/usr/lib/pm-utils/sleep.d/90clock suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/94cpufreq suspend suspend:

/usr/lib/pm-utils/sleep.d/94cpufreq suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/95led suspend suspend:

/usr/lib/pm-utils/sleep.d/95led suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/98video-quirk-db-handler suspend suspend:
Kernel modesetting video driver detected, not using quirks.

/usr/lib/pm-utils/sleep.d/98video-quirk-db-handler suspend suspend: success.
Running hook /etc/pm/sleep.d/999sync suspend suspend:

/etc/pm/sleep.d/999sync suspend suspend: success.
Running hook /usr/lib/pm-utils/sleep.d/99video suspend suspend:
kernel.acpi_video_flags = 0

/usr/lib/pm-utils/sleep.d/99video suspend suspend: success.
Fri Nov 11 12:40:53 ART 2011: performing suspend

--------------040906030300080106060700
Content-Type: text/plain;
 name="lspci"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lspci"

00:00.0 Host bridge [0600]: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT Express Memory Controller Hub [8086:27a0] (rev 03)
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: <access denied>
	Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated Graphics Controller [8086:27a2] (rev 03) (prog-if 00 [VGA controller])
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at ffe80000 (32-bit, non-prefetchable) [size=512K]
	Region 1: I/O ports at ec00 [size=8]
	Region 2: Memory at d0000000 (32-bit, prefetchable) [size=256M]
	Region 3: Memory at ffe40000 (32-bit, non-prefetchable) [size=256K]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: <access denied>
	Kernel driver in use: i915

00:02.1 Display controller [0380]: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller [8086:27a6] (rev 03)
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: Memory at ffd80000 (32-bit, non-prefetchable) [size=512K]
	Capabilities: <access denied>

00:1b.0 Audio device [0403]: Intel Corporation N10/ICH 7 Family High Definition Audio Controller [8086:27d8] (rev 02)
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 42
	Region 0: Memory at ffe34000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: snd_hda_intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge [0604]: Intel Corporation N10/ICH 7 Family PCI Express Port 1 [8086:27d0] (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: 80300000-804fffff
	Prefetchable memory behind bridge: 0000000080500000-00000000806fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1c.1 PCI bridge [0604]: Intel Corporation N10/ICH 7 Family PCI Express Port 2 [8086:27d2] (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000a000-0000afff
	Memory behind bridge: fef00000-ff2fffff
	Prefetchable memory behind bridge: 0000000080100000-00000000802fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1d.0 USB controller [0c03]: Intel Corporation N10/ICH 7 Family USB UHCI Controller #1 [8086:27c8] (rev 02) (prog-if 00 [UHCI])
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 4: I/O ports at e880 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.1 USB controller [0c03]: Intel Corporation N10/ICH 7 Family USB UHCI Controller #2 [8086:27c9] (rev 02) (prog-if 00 [UHCI])
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at e800 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.2 USB controller [0c03]: Intel Corporation N10/ICH 7 Family USB UHCI Controller #3 [8086:27ca] (rev 02) (prog-if 00 [UHCI])
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at e480 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.3 USB controller [0c03]: Intel Corporation N10/ICH 7 Family USB UHCI Controller #4 [8086:27cb] (rev 02) (prog-if 00 [UHCI])
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 16
	Region 4: I/O ports at e400 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.7 USB controller [0c03]: Intel Corporation N10/ICH 7 Family USB2 EHCI Controller [8086:27cc] (rev 02) (prog-if 20 [EHCI])
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at ffe3b800 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge [8086:2448] (rev e2) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=03, subordinate=04, sec-latency=32
	I/O behind bridge: 0000c000-0000dfff
	Memory behind bridge: 80000000-800fffff
	Prefetchable memory behind bridge: 00000000bdf00000-00000000bfefffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR+
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>

00:1f.0 ISA bridge [0601]: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge [8086:27b9] (rev 02)
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: <access denied>
	Kernel modules: iTCO_wdt, intel-rng

00:1f.2 IDE interface [0101]: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller [8086:27c4] (rev 02) (prog-if 80 [Master])
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at ffa0 [size=16]
	Capabilities: <access denied>
	Kernel driver in use: ata_piix
	Kernel modules: ata_piix

00:1f.3 SMBus [0c05]: Intel Corporation N10/ICH 7 Family SMBus Controller [8086:27da] (rev 02)
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at 0400 [size=32]
	Kernel driver in use: i801_smbus
	Kernel modules: i2c-i801

03:04.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ [10ec:8139] (rev 10)
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (8000ns min, 16000ns max)
	Interrupt: pin A routed to IRQ 10
	Region 0: I/O ports at d800 [size=256]
	Region 1: Memory at 80002800 (32-bit, non-prefetchable) [size=256]
	Capabilities: <access denied>

03:06.0 FireWire (IEEE 1394) [0c00]: O2 Micro, Inc. Firewire (IEEE 1394) [1217:00f7] (rev 02) (prog-if 10 [OHCI])
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at 80000000 (32-bit, non-prefetchable) [size=4K]
	Region 1: Memory at 80002000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: <access denied>
	Kernel driver in use: firewire_ohci
	Kernel modules: firewire-ohci

03:06.2 SD Host controller [0805]: O2 Micro, Inc. Integrated MMC/SD Controller [1217:7120] (rev 01)
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at 80002900 (32-bit, non-prefetchable) [size=256]
	Capabilities: <access denied>
	Kernel modules: sdhci-pci

03:06.3 Mass storage controller [0180]: O2 Micro, Inc. Integrated MS/xD Controller [1217:7130] (rev 01)
	Subsystem: TWINHEAD INTERNATIONAL Corp Device [14ff:a003]
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR+ INTx-
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at 80001000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>


--------------040906030300080106060700--
