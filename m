Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231Ab2I2HwA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 03:52:00 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37054 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab2I2Hv7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 03:51:59 -0400
MIME-Version: 1.0
Date: Sat, 29 Sep 2012 15:51:57 +0800
Message-ID: <CA+ZrtSCK4YS3Px6_cHQM7C_N7jSgfb_y8+-TNtdxjpE7kArsQw@mail.gmail.com>
Subject: utime and utime value stop increase in /proc/pid/stat
From: Han Xiao <arak.hx@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After running a cpu-consuming program(pid is 7332) under a 32-bit x86
SMP linux for 80 days£¬I find utime and stime field in /proc/7332/stat
stop increase, but the program seems still running right.

The wrong value in /proc/7332/stat cause 'top' and 'ps aux' output
wrong cpu % usage.

I guess this issue may happens when the sum of utime + stime is close
to 0xffffffff .


Here is some logs below:

# cat /proc/7332/stat
7332 (prog) R 7330 1173 1173 0 -1 4202496 1936595 0 0 0 2133359497
2133437350 0 0 15 -5 4 0 264907 2043727872 139368 4294967295 134512640
141884576 3215417504 3215416688 134589605 0 0 16783367 512 4294967295
0 0 17 3 0 0 0 0 0
# cat /proc/7332/stat
7332 (prog) R 7330 1173 1173 0 -1 4202496 1936595 0 0 0 2133359497
2133437350 0 0 15 -5 4 0 264907 2043727872 139368 4294967295 134512640
141884576 3215417504 3215416688 134588046 0 0 16783367 512 4294967295
0 0 17 3 0 0 0 0 0
# cat /proc/7332/stat
7332 (prog) R 7330 1173 1173 0 -1 4202496 1936595 0 0 0 2133359497
2133437350 0 0 15 -5 4 0 264907 2043727872 139368 4294967295 134512640
141884576 3215417504 3215416688 134588042 0 0 16783367 512 4294967295
0 0 17 3 0 0 0 0 0


# uname -a
Linux localhost 2.6.39-gentoo-r3 #50 SMP PREEMPT Sat Jun 9 11:34:08
CST 2012 i686 Intel(R) Core(TM) i3-2120 CPU @ 3.30GHz GenuineIntel
GNU/Linux

# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 42
model name      : Intel(R) Core(TM) i3-2120 CPU @ 3.30GHz
stepping        : 7
cpu MHz         : 3292.630
cache size      : 3072 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx rdtscp lm
constant_tsc arch_perfmon pebs bts xtopology nonstop_tsc aperfmperf
pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm
sse4_1 sse4_2 popcnt xsave avx lahf_lm arat epb xsaveopt pln pts dts
tpr_shadow vnmi flexpriority ept vpid
bogomips        : 6585.26
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 42
model name      : Intel(R) Core(TM) i3-2120 CPU @ 3.30GHz
stepping        : 7
cpu MHz         : 3292.630
cache size      : 3072 KB
physical id     : 0
siblings        : 4
core id         : 1
cpu cores       : 2
apicid          : 2
initial apicid  : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx rdtscp lm
constant_tsc arch_perfmon pebs bts xtopology nonstop_tsc aperfmperf
pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm
sse4_1 sse4_2 popcnt xsave avx lahf_lm arat epb xsaveopt pln pts dts
tpr_shadow vnmi flexpriority ept vpid
bogomips        : 6584.19
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 2
vendor_id       : GenuineIntel
cpu family      : 6
model           : 42
model name      : Intel(R) Core(TM) i3-2120 CPU @ 3.30GHz
stepping        : 7
cpu MHz         : 3292.630
cache size      : 3072 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx rdtscp lm
constant_tsc arch_perfmon pebs bts xtopology nonstop_tsc aperfmperf
pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm
sse4_1 sse4_2 popcnt xsave avx lahf_lm arat epb xsaveopt pln pts dts
tpr_shadow vnmi flexpriority ept vpid
bogomips        : 6584.18
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 6
model           : 42
model name      : Intel(R) Core(TM) i3-2120 CPU @ 3.30GHz
stepping        : 7
cpu MHz         : 3292.630
cache size      : 3072 KB
physical id     : 0
siblings        : 4
core id         : 1
cpu cores       : 2
apicid          : 3
initial apicid  : 3
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx rdtscp lm
constant_tsc arch_perfmon pebs bts xtopology nonstop_tsc aperfmperf
pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm
sse4_1 sse4_2 popcnt xsave avx lahf_lm arat epb xsaveopt pln pts dts
tpr_shadow vnmi flexpriority ept vpid
bogomips        : 6584.19
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

#top
top - 15:39:34 up 80 days, 21:31,  0 users,  load average: 3.91, 3.70, 3.67
Tasks: 102 total,   4 running,  98 sleeping,   0 stopped,   0 zombie
Cpu(s): 78.8%us,  2.2%sy,  0.0%ni, 18.9%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   8145408k total,  3136024k used,  5009384k free,    35956k buffers
Swap:        0k total,        0k used,        0k free,   458228k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 7332 root       15  -5 1949m 544m  20m R    0  6.8 711132:48 prog

# ps aux|grep 7332
root       7332  610  6.8 1209396 557472 ?      R<l  Jul10 711132:48 /root/prog

# ps -ef|grep 7332
nos       1438  8563  0 15:41 pts/3    00:00:00 grep 7332
nos       7332  7330 99 Jul10 ?        493-20:12:48 /root/prog
