Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684Ab1CSPm5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 11:42:57 -0400
Received: from mx0.vr-web.de ([195.200.35.198]:53630 "EHLO mx0.vr-web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754733Ab1CSPmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 11:42:54 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Mar 2011 11:42:54 EDT
From: Andreas Hartmann <andihartmann@01019freenet.de>
X-Newsgroups: linux.kernel
Subject: intel_ips produces constant load of 1
Date: Sat, 19 Mar 2011 16:38:38 +0100
Organization: privat
Message-ID: <im2ik4$3dd$1@ID-44327.news.uni-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b13pre) Gecko/20110316 Firefox/4.0b13pre SeaMonkey/2.1b2pre
To: linux-kernel@vger.kernel.org
X-BitDefender-Scanner: Clean, Agent: BitDefender Courier 3.0.2 on
 vrwf102, sigver: 7.36674
X-BitDefender-CF-Stamp: none
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

on my MSI CR620 laptop, intel_ips produces a constant load of 1, even if
the machine is idle.

The ips-monitor hangs in D state:

ps aux | grep ips
root       593  0.0  0.0      0     0 ?        S    17:20   0:00
[ips-adjust]
root       594  0.0  0.0      0     0 ?        D    17:20   0:00
[ips-monitor]

If the module isn't loaded, the load of the machine in idle mode is 0 as
expected.

Some more information about ips on this machine:

[   61.689778] intel ips 0000:00:1f.6: CPU TDP doesn't match expected
value (found 25, expected 29)
[   61.689805] intel ips 0000:00:1f.6: PCI INT C -> GSI 18 (level, low)
-> IRQ 18
[   61.690236] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp
limit 90

kernel: [17208.187382] intel ips 0000:00:1f.6: MCP limit exceeded: Avg
power 35102, limit 35000
kernel: [50357.822192] intel ips 0000:00:1f.6: MCP limit exceeded: Avg
power 39335, limit 35000Mar 17 18:46:31 linux-8fih kernel:
[50362.819118] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power
39823, limit 35000Mar 17 18:46:36 linux-8fih kernel: [50367.816045]
intel ips 0000:00:1f.6: MCP limit exceeded: Avg power 40540, limit
35000Mar 17 18:46:46 linux-8fih kernel: [50377.809947] intel ips
0000:00:1f.6: MCP limit exceeded: Avg power 36915, limit 35000Mar 17
18:47:01 linux-8fih kernel: [50392.800632] intel ips 0000:00:1f.6: MCP
limit exceeded: Avg power 39427, limit 35000Mar 17 18:47:11 linux-8fih
kernel: [50402.794479] intel ips 0000:00:1f.6: MCP limit exceeded: Avg
power 39781, limit 35000
kernel: [50407.791447] intel ips 0000:00:1f.6: MCP limit exceeded: Avg
power 37437, limit 35000
kernel: [50417.785250] intel ips 0000:00:1f.6: MCP limit exceeded: Avg
power 37682, limit 35000
kernel: [50422.782204] intel ips 0000:00:1f.6: MCP limit exceeded: Avg
power 35474, limit 35000


The CPU is:
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 37
model name      : Intel(R) Core(TM) i5 CPU       M 460  @ 2.53GHz
stepping        : 5
cpu MHz         : 2533.000
cache size      : 3072 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 11
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2
ssse3 cx16 xtpr pdcm sse4_1 sse4_2 popcnt lahf_lm arat dts tpr_shadow
vnmi flexpriority ept vpid
bogomips        : 5053.43
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

(+ another 3 times)



lspci of the signal processing controller:

00:1f.6 Signal processing controller: Intel Corporation 5 Series/3400
Series Chipset Thermal Subsystem (rev 05)
        Subsystem: Micro-Star International Co., Ltd. Device 1033
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin C routed to IRQ 11
        Region 0: Memory at f6804000 (64-bit, non-prefetchable) [size=4K]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
                Address: 00000000  Data: 0000


Do you need some more information? Please ask, I'll try to provide it!


Regards,
Andreas
