Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199Ab1JGQXD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 12:23:03 -0400
Received: from ezo.ezono.com ([50.22.105.208]:39583 "EHLO ezo.ezono.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760168Ab1JGQW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 12:22:58 -0400
Message-ID: <4E8F2758.3040408@ezono.com>
Date: Fri, 07 Oct 2011 18:22:48 +0200
From: Abdelghani Ouchabane <abdelghani@ezono.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: PCIe can not rescan for new PCIe device ( FPGA board )
References: <4E8EA746.6030103@ezono.com> <CAErSpo6YEp2v9xzVJHsu5WSJDqb+sWZUfS-e7UmGEXENRiWmnQ@mail.gmail.com>
In-Reply-To: <CAErSpo6YEp2v9xzVJHsu5WSJDqb+sWZUfS-e7UmGEXENRiWmnQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ezo.ezono.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - ezono.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> [added cc: linux-pci@vger.kernel.org]
>
> On Fri, Oct 7, 2011 at 1:16 AM, Abdelghani Ouchabane
> <abdelghani@ezono.com> wrote:
>   
>> Hallo,
>>
>>  We are developing a FPGA board connected to a Fedora 15 PC host over PCIe.
>> Right now, in the implementation and debug phase, I often need to power off
>> and
>> power on the device or try different boards. This causes a problem with the
>> Fedora 15 running on the AMD PC.
>>
>> Typically the PC is booted when I need to insert the device under test. As
>> expected, the Linux doesn't find the device and the software app cannot talk
>> to it.
>>
>> * If I do "lspci -v" then it does not list our device.
>>     
>
> Do you have pciehp enabled and loaded?  I would think a PCIe hot-add
> should automatically rescan the bus.  Does dmesg say anything when you
> do the hot-add?
>   
Thanks Bjorn,

Yes, I have them :

****************************************************************************************************
lsmod :

pciehp                 20282  0
cgosdrv                17632  0
****************************************************************************************************
/etc/modprobe.d/pciehp.conf
alias pci:v00001234d00000002sv00001234sd00000001bc11sc80i00 pciehp
options pciehp pciehp_force=1 pciehp_debug=1
****************************************************************************************************

After I plug my board in,  I executed  echo 1 > /sys/bus/pci/rescan

dmesg:

[   73.203895] pci 0000:02:00.0: [1234:0002] type 0 class 0x001180
[   73.203895] pci 0000:02:00.0: reg 10: [mem 0x00000000-0x00000fff 
64bit pref]
[   73.204083] pci 0000:02:00.0: reg 18: [mem 0x00000000-0x0003ffff 
64bit pref]
[   73.204114] pci 0000:02:00.0: reg 20: [mem 0x00000000-0x00000fff 
64bit pref]
[   73.206190] pci 0000:00:01.0: BAR 6: [??? 0x00000000 flags 0x2] has 
bogus alignment
[   73.206215] pci 0000:02:00.0: BAR 2: assigned [mem 
0x40200000-0x4023ffff 64bit pref]
[   73.206236] pci 0000:02:00.0: BAR 2: set to [mem 
0x40200000-0x4023ffff 64bit pref] (PCI address [0x40200000-0x4023ffff])
[   73.206247] pci 0000:02:00.0: BAR 0: assigned [mem 
0x40240000-0x40240fff 64bit pref]
[   73.206266] pci 0000:02:00.0: BAR 0: set to [mem 
0x40240000-0x40240fff 64bit pref] (PCI address [0x40240000-0x40240fff])
[   73.206277] pci 0000:02:00.0: BAR 4: assigned [mem 
0x40241000-0x40241fff 64bit pref]
[   73.206295] pci 0000:02:00.0: BAR 4: set to [mem 
0x40241000-0x40241fff 64bit pref] (PCI address [0x40241000-0x40241fff])

****************************************************************************************************
  
>   
>> * Then I execute "echo 1 > /sys/bus/pci/rescan"
>>
>> * Now "lspci -v" lists our device.
>>     
>
> That means config space accesses to your device seem to work fine.
>
>   
>> * But our software returns : 0xFFFFFFFF
>>     
>
> Your device is on bus 02.  Did you confirm that there are host bridge
> and P2P bridge apertures containing the BARs, e.g,. the [mem
> 0x40241000-0x40241fff] region?  The dmesg log should show all this
> information.
>   
Yes, it is on the bus 02.

Here is the log of dmesg :

[   69.806322] pci 0000:02:00.0: [1234:0002] type 0 class 0x001180
[   69.806426] pci 0000:02:00.0: reg 10: [mem 0x00000000-0x00000fff 
64bit pref]
[   69.806506] pci 0000:02:00.0: reg 18: [mem 0x00000000-0x0003ffff 
64bit pref]
[   69.806585] pci 0000:02:00.0: reg 20: [mem 0x00000000-0x00000fff 
64bit pref]
[   69.808194] pci 0000:00:01.0: BAR 6: [??? 0x00000000 flags 0x2] has 
bogus alignment
[   69.808271] pci 0000:02:00.0: BAR 2: assigned [mem 
0x40200000-0x4023ffff 64bit pref]
[   69.808343] pci 0000:02:00.0: BAR 2: set to [mem 
0x40200000-0x4023ffff 64bit pref] (PCI address [0x40200000-0x4023ffff])
[   69.808412] pci 0000:02:00.0: BAR 0: assigned [mem 
0x40240000-0x40240fff 64bit pref]
[   69.808650] pci 0000:02:00.0: BAR 0: set to [mem 
0x40240000-0x40240fff 64bit pref] (PCI address [0x40240000-0x40240fff])
[   69.808888] pci 0000:02:00.0: BAR 4: assigned [mem 
0x40241000-0x40241fff 64bit pref]
[   69.810805] pci 0000:02:00.0: BAR 4: set to [mem 
0x40241000-0x40241fff 64bit pref] (PCI address [0x40241000-0x40241fff])
[   84.309870] pci 0000:02:00.0: enabling device (0000 -> 0002)
[   84.310082] pci 0000:02:00.0: PCI INT A -> Link[LNKB] -> GSI 7 
(level, low) -> IRQ 7
[   85.581946] pci 0000:02:00.0: [1234:0002] type 0 class 0x001180
[   85.582300] pci 0000:02:00.0: reg 10: [mem 0x40240000-0x40240fff 
64bit pref]
[   85.582467] pci 0000:02:00.0: reg 18: [mem 0x40200000-0x4023ffff 
64bit pref]
[   85.582631] pci 0000:02:00.0: reg 20: [mem 0x40241000-0x40241fff 
64bit pref]
[   85.584195] pci 0000:00:01.0: BAR 6: [??? 0x00000000 flags 0x2] has 
bogus alignment
[   85.584442] pci 0000:02:00.0: BAR 2: assigned [mem 
0x40200000-0x4023ffff 64bit pref]
[   85.584682] pci 0000:02:00.0: BAR 2: set to [mem 
0x40200000-0x4023ffff 64bit pref] (PCI address [0x40200000-0x4023ffff])
[   85.584921] pci 0000:02:00.0: BAR 0: assigned [mem 
0x40240000-0x40240fff 64bit pref]
[   85.585346] pci 0000:02:00.0: BAR 0: set to [mem 
0x40240000-0x40240fff 64bit pref] (PCI address [0x40240000-0x40240fff])
[   85.585587] pci 0000:02:00.0: BAR 4: assigned [mem 
0x40241000-0x40241fff 64bit pref]
[   85.585826] pci 0000:02:00.0: BAR 4: set to [mem 
0x40241000-0x40241fff 64bit pref] (PCI address [0x40241000-0x40241fff])
[   86.915177] pci 0000:02:00.0: PCI INT A -> Link[LNKB] -> GSI 7 
(level, low) -> IRQ 7

****************************************************************************************************

Many thanks in advance.

Cheers,
Ghani
