Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab1HHMlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 08:41:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336Ab1HHMlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 08:41:51 -0400
Message-ID: <4E3FD98C.8040607@redhat.com>
Date: Mon, 08 Aug 2011 14:41:48 +0200
From: Josef Lusticky <jlustick@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: Unable to handle kernel paging request
Content-Type: multipart/mixed;
 boundary="------------020205040600080900070407"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020205040600080900070407
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit

1.
I get kernel panic when loading and unloading presented modules saying 
BUG: Unable to handle kernel paging request.

2.
I've written short script that finds all available modules on system and 
tries to
load and unload them - see attachment or http://pastebin.com/dphQp2D3
I've tried several machines with different kernels and architectures
and always got kernel panic, oops or not responding system.
The problem is the panic is always caused by different module on 
different machines and with different kernels but some of call traces 
are similar and they always begin with "BUG: unable to handle kernel 
paging request at" + address.
I've been using module-init-tools 3.9 and 3.16 (most recent).
Here are examples of output:
stable kernel 3.0 on x86_64 machine: http://pastebin.com/WKAEdSjE
stable kernel 2.6.39.3 on x86_64 machine: http://pastebin.com/3XNy5n3B
stable lts kernel 2.6.32.43 on x86_64 machine: http://pastebin.com/rYzH6y2B
stable lts kernel 2.6.32.43 on i386 machine: http://pastebin.com/qSnLTch2

The problem does not occur when loading and unloading one module.
The problem does not occur after certain amounts of loaded modules.
When I choose a different order of modules (e.g. using sort) I get panic 
on different module.

3.
modules, kernel

4.1.
Linux version 3.0.0 (root@hp-xw4600-01.rhts.eng.bos.redhat.com) (gcc 
version 4.4.6 20110720 (Red Hat 4.4.6-1) (GCC) ) #1 SMP Wed Aug 3 
10:24:08 EDT 2011

4.2.
http://pastebin.com/CggeGTbt

6.
http://pastebin.com/WKAEdSjE

7.
http://pastebin.com/dphQp2D3

8.1.
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux hp-xw4600-01.rhts.eng.bos.redhat.com 3.0.0 #1 SMP Wed Aug 3 
10:24:08 EDT 2011 x86_64 x86_64 x86_64 GNU/Linux

Gnu C                  4.4.6
Gnu make               3.81
binutils               2.20.51.0.2
5.24.
util-linux             2.17.2
mount                  support
module-init-tools      3.16
e2fsprogs              1.41.12
pcmciautils            015
quota-tools            3.17.
Linux C Library        2.12
Dynamic linker (ldd)   2.12
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15
Sh-utils               8.4
wireless-tools         29
Modules Loaded         sunrpc cpufreq_ondemand acpi_cpufreq freq_table 
mperf ipv6 dm_mirror dm_region_hash dm_log ppdev parport_pc parport 
hp_wmi sparse_keymap rfkill microcode pcspkr sg tg3 iTCO_wdt 
iTCO_vendor_support serio_raw snd_hda_codec_realtek snd_hda_intel 
snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd 
soundcore snd_page_alloc x38_edac edac_core ext4 mbcache jbd2 floppy 
sr_mod cdrom sd_mod crc_t10dif ahci libahci nouveau ttm drm_kms_helper 
drm i2c_algo_bit i2c_core mxm_wmi wmi video dm_mod


8.2.
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Duo CPU     E6550  @ 2.33GHz
stepping        : 11
cpu MHz         : 1998.000
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe 
syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl 
aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr 
pdcm lahf_lm dts tpr_shadow vnmi flexpriority
bogomips        : 4666.71
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Duo CPU     E6550  @ 2.33GHz
stepping        : 11
cpu MHz         : 1998.000
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
x smx est tm2 ssse3 cx16 xtpr pdcm lahf_lm dts tpr_shadow vnmi flexpriority
bogomips        : 4666.63
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

8.3.
sunrpc 236076 1 - Live 0xffffffffa044d000
cpufreq_ondemand 6970 2 - Live 0xffffffffa0448000
acpi_cpufreq 10611 0 - Live 0xffffffffa0441000
freq_table 5938 2 cpufreq_ondemand,acpi_cpufreq, Live 0xffffffffa043b000
mperf 1451 1 acpi_cpufreq, Live 0xffffffffa0437000
ipv6 329536 38 - Live 0xffffffffa03cb000
dm_mirror 14316 0 - Live 0xffffffffa03c3000
dm_region_hash 10843 1 dm_mirror, Live 0xffffffffa03bc000
dm_log 9766 2 dm_mirror,dm_region_hash, Live 0xffffffffa03b5000
ppdev 8326 0 - Live 0xffffffffa03af000
parport_pc 22656 0 - Live 0xffffffffa03a4000
parport 35464 2 ppdev,parport_pc, Live 0xffffffffa0395000
hp_wmi 8572 0 - Live 0xffffffffa038e000
sparse_keymap 4138 1 hp_wmi, Live 0xffffffffa0201000
rfkill 18959 1 hp_wmi, Live 0xffffffffa0382000
microcode 111961 0 - Live 0xffffffffa0362000
pcspkr 1926 0 - Live 0xffffffffa0042000
sg 30233 0 - Live 0xffffffffa0355000
tg3 143037 0 - Live 0xffffffffa032a000
iTCO_wdt 13346 0 - Live 0xffffffffa0321000
iTCO_vendor_support 2982 1 iTCO_wdt, Live 0xffffffffa002e000
serio_raw 4552 0 - Live 0xffffffffa01c1000
snd_hda_codec_realtek 323293 1 - Live 0xffffffffa02c5000
snd_hda_intel 24797 0 - Live 0xffffffffa02b9000
00
snd_hwdep 6692 1 snd_hda_codec, Live 0xffffffffa01a8000
snd_seq 55841 0 - Live 0xffffffffa0288000
snd_seq_device 6496 1 snd_seq, Live 0xffffffffa018a000
snd_pcm 85898 2 snd_hda_intel,snd_hda_codec, Live 0xffffffffa0269000
snd_timer 22510 2 snd_seq,snd_pcm, Live 0xffffffffa00b2000
snd_seq_device,snd_pcm,snd_timer, Live 0xffffffffa016e000
soundcore 7604 1 snd, Live 0xffffffffa0029000
snd_page_alloc 8428 2 snd_hda_intel,snd_pcm, Live 0xffffffffa0039000
x38_edac 3531 0 - Live 0xffffffffa0021000
edac_core 46451 2 x38_edac, Live 0xffffffffa007c000
ext4 408269 3 - Live 0xffffffffa0204000
mbcache 7222 1 ext4, Live 0xffffffffa01fe000
jbd2 81684 1 ext4, Live 0xffffffffa01e0000
floppy 65813 0 - Live 0xffffffffa01c4000
sr_mod 15404 0 - Live 0xffffffffa01bc000
cdrom 41095 1 sr_mod, Live 0xffffffffa01ac000
sd_mod 37218 3 - Live 0xffffffffa019d000
crc_t10dif 1499 1 sd_mod, Live 0xffffffffa0199000
ahci 21890 2 - Live 0xffffffffa018e000
libahci 23517 1 ahci, Live 0xffffffffa0183000
nouveau 732409 1 - Live 0xffffffffa00ba000
ttm 66684 1 nouveau, Live 0xffffffffa00a0000
drm_kms_helper 33063 1 nouveau, Live 0xffffffffa0091000
drm 225207 3 nouveau,ttm,drm_kms_helper, Live 0xffffffffa0044000
i2c_algo_bit 5928 1 nouveau, Live 0xffffffffa003f000
0
mxm_wmi 1883 1 nouveau, Live 0xffffffffa002c000
wmi 10412 2 hp_wmi,mxm_wmi, Live 0xffffffffa0025000
video 12943 1 nouveau, Live 0xffffffffa001c000
dm_mod 75743 11 dm_mirror,dm_log, Live 0xffffffffa0000000

8.4.
ioports: http://pastebin.com/vJHHNp3A
iomem: http://pastebin.com/aYAnmJX1

8.5.
lspci -vvv: http://pastebin.com/uf3wFdCa

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: Hitachi HDS72168 Rev: P21O
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
   Vendor: ATAPI    Model: DVD D  DH16DYS   Rev: XH31
   Type:   CD-ROM                           ANSI  SCSI revision: 05



Josef Lusticky

--------------020205040600080900070407
Content-Type: application/x-sh;
 name="mods.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mods.sh"

#!/bin/bash
# version 3
RELEASE=`uname -r`

echo `date`
echo "*** STARTING TEST	***"

#for MODULE in `find /lib/modules/"$RELEASE"/ -type f -iname '*.o' -or -iname '*.ko'`
for MODULE in `find /lib/modules/"$RELEASE"/ -type f -iname '*.ko'`
do
	#MODULE=`echo $MODULE | sed 's#^.*/\(.*\)\.ko#\1#g'`
	MODULE=`basename "$MODULE" .ko`
	modinfo $MODULE > /dev/null || exit
	LOADED=`lsmod | grep '"$MODULE"'`

	echo "*** Removing module ${MODULE} ***"
	modprobe -r "$MODULE" || continue
	echo "*** Loading module ${MODULE} ***"
	modprobe "$MODULE" || continue

	# unload module back if it was not loaded before
	if [ -z "$LOADED" ]; then
		modprobe -r "$MODULE" || continue
	fi
done

echo `date`
echo "*** END OF TEST ***"

--------------020205040600080900070407--
