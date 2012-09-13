Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab2IMBak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 21:30:40 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:2229 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751214Ab2IMBaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 21:30:39 -0400
Message-ID: <50513733.8040801@blueyonder.co.uk>
Date: Thu, 13 Sep 2012 02:30:27 +0100
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: LKML Mailing List <linux-kernel@vger.kernel.org>
Subject: AMD Bulldozer FX-8150 Powers off during kernel build
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Cloudmark-Analysis: v=1.1 cv=GaEGOwq9FwezmTggA+b6yC6zDZF2HYaK6RN/tSqdnVA= c=1 sm=0 a=beXUTUSmZ6sA:10 a=lFDGhQ1XsWEA:10 a=3NElcqgl2aoA:10 a=k1j_C7plYBUA:10 a=8nJEP1OIZ-IA:10 a=-xESdocTVQBKntGDdugA:9 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a huge heatsink and large CPU fan plus lots of cooling fans in 
the case and nothing gets hot.
If I build e.g 3.6-rc5 with 8 or 6 cores, part way through it suddenly 
powers off.

I have checked hwmon/k10temp.c to see if I could see where these values 
were defined.

k10temp.h is 0 bytes.
-rw-r--r-- 1 root root 0 Sep  9 01:59 
/usr/src/linux-3.6.0-rc5/include/config/sensors/k10temp.h

Currently I build with "make -j 1" and temperature and power values are 
around those below.
# sensors
k10temp-pci-00c3
Adapter: PCI adapter
temp1:        +60.4°C  (high = +70.0°C)
                        (crit = +90.0°C, hyst = +87.0°C)

fam15h_power-pci-00c4
Adapter: PCI adapter
power1:      127.49 W  (crit = 124.77 W)

# cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 21
model           : 1
model name      : AMD FX(tm)-8150 Eight-Core Processor
stepping        : 2
microcode       : 0x6000626
cpu MHz         : 3600.000
cache size      : 2048 KB

from .config:-
# grep HWMON .config
CONFIG_IXGBE_HWMON=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL_HWMON=y

# grep POWERSAVE .config
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
# CONFIG_PCIEASPM_POWERSAVE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=y

On another 6-core box I can build kernels with "make -j 6" without problems.
# cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 21
model           : 1
model name      : AMD FX(tm)-6100 Six-Core Processor
stepping        : 2
microcode       : 0x6000623
cpu MHz         : 3300.000
cache size      : 2048 KB

With a kernel build going on six core box, temperature and power hover 
around the values below.
sabre:~ # sensors
k10temp-pci-00c3
Adapter: PCI adapter
temp1:        +50.2°C  (high = +70.0°C)
                        (crit = +90.0°C, hyst = +87.0°C)

fam15h_power-pci-00c4
Adapter: PCI adapter
power1:       94.40 W  (crit =  95.01 W)

73 ... Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Senior Staff Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

