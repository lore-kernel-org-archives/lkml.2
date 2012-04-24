Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab2DXUz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 16:55:57 -0400
Received: from smtp121.dfw.emailsrvr.com ([67.192.241.121]:50933 "EHLO
	smtp121.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096Ab2DXUz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 16:55:56 -0400
Message-ID: <4F97135A.2060801@calxeda.com>
Date: Tue, 24 Apr 2012 15:55:54 -0500
From: Rob Herring <rob.herring@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
CC: minyard@acm.org, linux-kernel@vger.kernel.org, tcminyard@gmail.com
Subject: Re: [BISECTED] ipmi_si not loading since 2.6.39
References: <20120420223833.GA7855@nik-comp.lan> <20120421072056.GA2033@nik-comp.lan> <4F95B6F3.3010303@calxeda.com> <4F96AD8C.9010105@acm.org> <20120424203745.GB2152@nik-comp.lan>
In-Reply-To: <20120424203745.GB2152@nik-comp.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 03:37 PM, Nikola Ciprich wrote:
> Hi Corey,
> 
> I have this problem with 3.4-rc4 as well and it already contains
> b1608d69cb804e414d0887140ba08a9398e4e638, so this doesn't fix this problem..
> 

Can you send the kernel log for the failing case.

Rob

> BR
> 
> nik
> 
> 
> On Tue, Apr 24, 2012 at 08:41:32AM -0500, Corey Minyard wrote:
>> Looks like you might need change b1608d69cb804e414d0887140ba08a9398e4e638
>>
>> -corey
>>
>> On 04/23/2012 03:09 PM, Rob Herring wrote:
>>> On 04/21/2012 02:20 AM, Nikola Ciprich wrote:
>>>> Hi,
>>>>
>>>> here's further information Rob and Corey requested:
>>>>
>>>> on working system:
>>>>
>>>> [root@vbox4 ~]# cat /proc/ipmi/0/params
>>>> kcs,i/o,0xca2,rsp=1,rsi=1,rsh=0,irq=0,ipmb=0
>>>>
>>>> dmesg snippet:
>>>>
>>>> [   41.759319] ipmi message handler version 39.2
>>>> [   41.760690] ipmi device interface
>>>> [   42.765334] IPMI System Interface driver.
>>>> [   42.765336] ipmi_si: probing via hardcoded address
>>>> [   42.765337] ipmi_si: Adding hardcoded-specified kcs state machine
>>>> [   42.765340] ipmi_si: Trying hardcoded-specified kcs state machine at i/o address 0xca8, slave address 0x0, irq 0
>>>> [   42.765344] ipmi_si: Interface detection failed
>>>> [   42.770823] ipmi_si: probing via SMBIOS
>>>> [   42.770834] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
>>>> [   42.770836] ipmi_si: Adding SMBIOS-specified kcs state machine
>>>> [   42.770838] ipmi_si: probing via SPMI
>>>> [   42.770840] ipmi_si: SPMI: io 0xe4 regsize 1 spacing 1 irq 0
>>>> [   42.770841] ipmi_si: Adding SPMI-specified kcs state machine
>>>> [   42.770843] ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
>>>> [   42.798137] ipmi_si ipmi_si.0: Error clearing flags: cc
>>>> [   42.801011] ipmi_si ipmi_si.0: Found new BMC (man_id: 0x002a7c, prod_id: 0x0624, dev_id: 0x20)
>>>> [   42.801068] ipmi_si ipmi_si.0: IPMI kcs interface initialized
>>>>
>>>>
>>>> dmidecode:
>>>>
>>>> IPMI Device Information
>>>>          Interface Type: KCS (Keyboard Control Style)
>>>>          Specification Version: 2.0
>>>>          I2C Slave Address: 0x00
>>>>          NV Storage Device: Not Present
>>>>          Base Address: 0x0000000000000CA2 (I/O)
>>>>          Register Spacing: Successive Byte Boundaries
>>>>
>>>> Base Board Information
>>>>          Manufacturer: Supermicro
>>>>          Product Name: X9SCL/X9SCM
>>>>
>>>> (but we're experiencing this on various supermicro bords, ie X8DTL)
>>>>
>>>> Tried setting parameters by hand didn't help:
>>>>
>>>> modprobe ipmi_si type=kcs addrs=0xca8 regspacings=1 regsizes=1 regshifts=0 irqs=0 slave_addrs=0x0
>>>>
>>>> (not sure whether I got them correct though, and values mostly seem to me to be defaults anyways..)
>>>>
>>> It is working for me on a SuperMicro system with ubuntu oneiric (3.0
>>> based).
>>>
>>> [597160.259728] ipmi_si: probing via SMBIOS
>>> [597160.259730] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
>>> [597160.259731] ipmi_si: Adding SMBIOS-specified kcs state machine
>>> [597160.259734] ipmi_si: probing via SPMI
>>> [597160.259735] ipmi_si: SPMI: io 0xe4 regsize 1 spacing 1 irq 0
>>> [597160.259737] ipmi_si: Adding SPMI-specified kcs state machine
>>> [597160.259739] ipmi_si: Trying SMBIOS-specified kcs state machine at
>>> i/o address 0xca2, slave address 0x0, irq 0
>>> [597160.378757] ipmi_si: Invalid return from get global enables command,
>>> cannot enable the event buffer.
>>> [597160.382032] ipmi_si ipmi_si.0: Found new BMC (man_id: 0x00b980,
>>> prod_id: 0x0624, dev_id: 0x20)
>>> [597160.382040] ipmi_si ipmi_si.0: IPMI kcs interface initialized
>>> [597179.973960] ipmi device interface
>>> localadm@sandy1:~$ ipmitool bmc info
>>> Could not open device at /dev/ipmi0 or /dev/ipmi/0 or /dev/ipmidev/0: No
>>> such file or directory
>>> Get Device ID command failed
>>> localadm@sandy1:~$ sudo ipmitool bmc info
>>> Device ID                 : 32
>>> Device Revision           : 1
>>> Firmware Revision         : 1.1
>>> IPMI Version              : 2.0
>>> Manufacturer ID           : 47488
>>> Manufacturer Name         : Unknown (0xB980)
>>> Product ID                : 1572 (0x0624)
>>> Product Name              : Unknown (0x624)
>>> Device Available          : yes
>>> Provides Device SDRs      : no
>>> Additional Device Support :
>>>      Sensor Device
>>>      SDR Repository Device
>>>      SEL Device
>>>      FRU Inventory Device
>>>      IPMB Event Receiver
>>>      IPMB Event Generator
>>>      Chassis Device
>>> Aux Firmware Rev Info     :
>>>      0x06
>>>      0x00
>>>      0x00
>>>      0x00
>>> localadm@sandy1:~$ uname -a
>>> Linux sandy1 3.0.0-16-generic #28-Ubuntu SMP Fri Jan 27 17:44:39 UTC
>>> 2012 x86_64 x86_64 x86_64 GNU/Linux
>>>
>>> Rob
>>>
>>>> nik
>>>>
>>>>
>>>> On Sat, Apr 21, 2012 at 12:38:33AM +0200, Nikola Ciprich wrote:
>>>>> Hello,
>>>>>
>>>>> I was trying to find out why IPMI stopped working on new kernels. Since 2.6.39
>>>>> module loading ends with following message:
>>>>>
>>>>>   ipmi_si: Interface detection failed
>>>>>
>>>>> Then ipmitool is unable to control IPMI device.
>>>>>
>>>>> Works for 2.6.38, doesn't work for 2.6.39, 3.0.28, 3.4-rc1.
>>>>>
>>>>> I got this bisected to following commit:
>>>>>
>>>>> commit a1e9c9dd3383e6a1a762464ad604b1081774dbda
>>>>> Author: Rob Herring<rob.herring@calxeda.com>
>>>>> Date:   Wed Feb 23 15:37:59 2011 -0600
>>>>>
>>>>>      ipmi: convert OF driver to platform driver
>>>>>
>>>>>      of_bus is deprecated in favor of the plain platform bus. This patch
>>>>>      merges the ipmi OF driver with the existing platform driver.
>>>>>
>>>>>      CONFIG_PPC_OF occurrances are removed or replaced with CONFIG_OF.
>>>>>
>>>>>      Compile tested with and without CONFIG_OF. Tested OF probe and
>>>>>      default probe cases.
>>>>>
>>>>>      Signed-off-by: Rob Herring<rob.herring@calxeda.com>
>>>>>      Signed-off-by: Grant Likely<grant.likely@secretlab.ca>
>>>>>
>>>>> I wonder whether this is a bug, or I'm doing something wrong?
>>>>>
>>>>> Thanks in advance!
>>>>>
>>>>> with best regards
>>>>>
>>>>> nik
>>>>>
>>>>>
>>>>> -- 
>>>>> -------------------------------------
>>>>> Ing. Nikola CIPRICH
>>>>> LinuxBox.cz, s.r.o.
>>>>> 28. rijna 168, 709 01 Ostrava
>>>>>
>>>>> tel.:   +420 596 603 142
>>>>> fax:    +420 596 621 273
>>>>> mobil:  +420 777 093 799
>>>>>
>>>>> www.linuxbox.cz
>>>>>
>>>>> mobil servis: +420 737 238 656
>>>>> email servis: servis@linuxbox.cz
>>>>> -------------------------------------
>>>>
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 
