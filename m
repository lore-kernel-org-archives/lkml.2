Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab2IMJoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 05:44:19 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46692 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab2IMJoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 05:44:17 -0400
Date: Thu, 13 Sep 2012 11:44:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: Sid Boyce <sboyce@blueyonder.co.uk>
Cc: LKML Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: AMD Bulldozer FX-8150 Powers off during kernel build
Message-ID: <20120913094413.GB15810@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Sid Boyce <sboyce@blueyonder.co.uk>,
	LKML Mailing List <linux-kernel@vger.kernel.org>,
	Andreas Herrmann <andreas.herrmann3@amd.com>
References: <50513733.8040801@blueyonder.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50513733.8040801@blueyonder.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 02:30:27AM +0100, Sid Boyce wrote:
> I have a huge heatsink and large CPU fan plus lots of cooling fans
> in the case and nothing gets hot.
> If I build e.g 3.6-rc5 with 8 or 6 cores, part way through it
> suddenly powers off.

Ok, can you catch the whole dmesg when you boot the machine _after_ the
sudden poweroff? You can send it to me and Andreas (on CC) privately if
you prefer.

Important: make sure the kernel has CONFIG_X86_MCE and
CONFIG_EDAC_DECODE_MCE built-in.

Please make sure to use a recent kernel, i.e. 3.4, 3.5 is fine.

Thanks.

(Leaving in the rest for reference)

> I have checked hwmon/k10temp.c to see if I could see where these
> values were defined.
> 
> k10temp.h is 0 bytes.
> -rw-r--r-- 1 root root 0 Sep  9 01:59
> /usr/src/linux-3.6.0-rc5/include/config/sensors/k10temp.h
> 
> Currently I build with "make -j 1" and temperature and power values
> are around those below.
> # sensors
> k10temp-pci-00c3
> Adapter: PCI adapter
> temp1:        +60.4°C  (high = +70.0°C)
>                        (crit = +90.0°C, hyst = +87.0°C)
> 
> fam15h_power-pci-00c4
> Adapter: PCI adapter
> power1:      127.49 W  (crit = 124.77 W)
> 
> # cat /proc/cpuinfo
> processor       : 0
> vendor_id       : AuthenticAMD
> cpu family      : 21
> model           : 1
> model name      : AMD FX(tm)-8150 Eight-Core Processor
> stepping        : 2
> microcode       : 0x6000626
> cpu MHz         : 3600.000
> cache size      : 2048 KB
> 
> from .config:-
> # grep HWMON .config
> CONFIG_IXGBE_HWMON=y
> CONFIG_HWMON=y
> CONFIG_HWMON_VID=m
> # CONFIG_HWMON_DEBUG_CHIP is not set
> CONFIG_THERMAL_HWMON=y
> 
> # grep POWERSAVE .config
> # CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
> CONFIG_CPU_FREQ_GOV_POWERSAVE=m
> # CONFIG_PCIEASPM_POWERSAVE is not set
> CONFIG_DEVFREQ_GOV_POWERSAVE=y
> 
> On another 6-core box I can build kernels with "make -j 6" without problems.
> # cat /proc/cpuinfo
> processor       : 0
> vendor_id       : AuthenticAMD
> cpu family      : 21
> model           : 1
> model name      : AMD FX(tm)-6100 Six-Core Processor
> stepping        : 2
> microcode       : 0x6000623
> cpu MHz         : 3300.000
> cache size      : 2048 KB
> 
> With a kernel build going on six core box, temperature and power
> hover around the values below.
> sabre:~ # sensors
> k10temp-pci-00c3
> Adapter: PCI adapter
> temp1:        +50.2°C  (high = +70.0°C)
>                        (crit = +90.0°C, hyst = +87.0°C)
> 
> fam15h_power-pci-00c4
> Adapter: PCI adapter
> power1:       94.40 W  (crit =  95.01 W)
> 
> 73 ... Sid.
> 
> -- 
> Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
> Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
> Senior Staff Specialist, Cricket Coach
> Microsoft Windows Free Zone - Linux used for all Computing Tasks
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Regards/Gruss,
    Boris.
