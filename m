Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab0ETAjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 20:39:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27497 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab0ETAjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 20:39:23 -0400
Message-ID: <4BF48425.2040702@oracle.com>
Date: Wed, 19 May 2010 17:36:53 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Graham Ramsey <ramsey.graham@ntlworld.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: x86/pci Oops with CONFIG_SND_HDA_INTEL
References: <4BF40014.30303@ntlworld.com>	<201005191044.05072.bjorn.helgaas@hp.com>	<4BF41CFD.6040004@ntlworld.com>	<4BF42786.2080603@oracle.com>	<4BF46A92.5050706@ntlworld.com>	<4BF47C38.9020101@oracle.com> <20100519172221.73702261@virtuousgeek.org>
In-Reply-To: <20100519172221.73702261@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090202.4BF484B9.000C:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2010 05:22 PM, Jesse Barnes wrote:
> On Wed, 19 May 2010 17:03:04 -0700
> Yinghai <yinghai.lu@oracle.com> wrote:
> 
>> On 05/19/2010 03:47 PM, Graham Ramsey wrote:
>>> On 19/05/10 19:01, Yinghai wrote:
>>>> On 05/19/2010 10:16 AM, Graham Ramsey wrote:
>>>>   
>>>>> On 19/05/10 17:44, Bjorn Helgaas wrote:
>>>>>     
>>>>>> On Wednesday, May 19, 2010 09:13:24 am Graham Ramsey wrote:
>>>>>>
>>>>>>       
>>>>>>> I am on x86_64 with latest (v2.6.34) kernel. When i set
>>>>>>> CONFIG_SND_HDA_INTEL=Y It hangs at an early stage in boot with kernel
>>>>>>> oops.
>>>>>>> When i use CONFIG_SND_HDA_INTEL=M the machine will boot, and i get the
>>>>>>> dmesg (below).
>>>>>>>
>>>>>>> I have bisected down to one commit that causes the problem:
>>>>>>>
>>>>>>>      commit 3e3da00c01d050307e753fb7b3e84aefc16da0d0
>>>>>>>      x86/pci: AMD one chain system to use pci read out res
>>>>>>>      ...
>>>>>>>
>>>>>>>          
>>>>>> I CC'd Yinghai, the author of that patch.  That commit went in after
>>>>>> 2.6.33, so this is probably a regression between .33 and .34.  Can
>>>>>> you open a report at https://bugzilla.kernel.org and respond to this
>>>>>> thread with the URL?
>>>>>>
>>>>>> Please attach the complete dmesg (with SND_HDA_INTEL=m) to the
>>>>>> bugzilla.
>>>>>>
>>>>>> Thanks a lot for your report!
>>>>>>
>>>>>>        
>>>> please send out bootlog with pci=earlydump.
>>>>
>>>> looks like your system have a very sick BIOS,
>>>>
>>>> system have two HT chains.
>>>>
>>>> PCI: Probing PCI hardware (bus 00)
>>>> ...
>>>> PCI: Discovered primary peer bus 80 [IRQ]
>>>>
>>>>
>>>> rt to non-coherent only set one link:
>>>> node 0 link 0: io port [1000, ffffff]
>>>> TOM: 0000000080000000 aka 2048M
>>>> node 0 link 0: mmio [e0000000, efffffff]
>>>> node 0 link 0: mmio [a0000, bffff]
>>>> node 0 link 0: mmio [80000000, ffffffff]
>>>> bus: [00, ff] on node 0 link 0
>>>>
>>>> YH
>>>>
>>>>    
>>> I have uploaded full boot log (of a working kernel) to bug if that is ok
>>>
>>> https://bugzilla.kernel.org/attachment.cgi?id=26444
>>>
>>
>> ah, that 80:01.0 is standalone device, the system still only have one HT chain.
>>
>> that is CRAZY that they can sell those poor designed chips.
>>
>> actually 3e3da00c is fixing another bug with one HT chain.
>>
>> Jesse,
>> We have two options:
>> 1. revert that 3e3da00c
>> 2. or use quirks to black out system with VIA chipset.
>>
>> please let me know which one you prefer.
> 
> I'm guessing these VIA chipsets are pretty common; how common is the
> platform bug you fixed with 3e3da00c?

one laptop with firewire on AMD 64 bit laptop. can not find the mail any more.

> 
> I'd rather quirk one platform than a whole bunch...

maybe you you can revert that patch at first.

Thanks

Yinghai
