Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab1JKBkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 21:40:55 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41428 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab1JKBky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 21:40:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E939E5D.3010208@jp.fujitsu.com>
Date: Tue, 11 Oct 2011 10:39:41 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Abdelghani Ouchabane <abdelghani@ezono.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: PCIe can not rescan for new PCIe device ( FPGA board )
References: <4E8EA746.6030103@ezono.com> <CAErSpo6YEp2v9xzVJHsu5WSJDqb+sWZUfS-e7UmGEXENRiWmnQ@mail.gmail.com> <4E8F2758.3040408@ezono.com> <CAErSpo6Lo2bXw=yjscQ6zzRMnpMZ-cUzbBxN3dDS1D3M67sQ8g@mail.gmail.com>
In-Reply-To: <CAErSpo6Lo2bXw=yjscQ6zzRMnpMZ-cUzbBxN3dDS1D3M67sQ8g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/10/08 1:36), Bjorn Helgaas wrote:
> On Fri, Oct 7, 2011 at 10:22 AM, Abdelghani Ouchabane
> <abdelghani@ezono.com>  wrote:
>> Bjorn Helgaas wrote:
>>>
>>> [added cc: linux-pci@vger.kernel.org]
>>>
>>> On Fri, Oct 7, 2011 at 1:16 AM, Abdelghani Ouchabane
>>> <abdelghani@ezono.com>  wrote:
>>>
>>>>
>>>> Hallo,
>>>>
>>>>   We are developing a FPGA board connected to a Fedora 15 PC host over
>>>> PCIe.
>>>> Right now, in the implementation and debug phase, I often need to power
>>>> off
>>>> and
>>>> power on the device or try different boards. This causes a problem with
>>>> the
>>>> Fedora 15 running on the AMD PC.
>>>>
>>>> Typically the PC is booted when I need to insert the device under test.
>>>> As
>>>> expected, the Linux doesn't find the device and the software app cannot
>>>> talk
>>>> to it.
>>>>
>>>> * If I do "lspci -v" then it does not list our device.
>>>>
>>>
>>> Do you have pciehp enabled and loaded?  I would think a PCIe hot-add
>>> should automatically rescan the bus.  Does dmesg say anything when you
>>> do the hot-add?
>>>
>>
>> Thanks Bjorn,
>>
>> Yes, I have them :
>>
>> ****************************************************************************************************
>> lsmod :
>>
>> pciehp                 20282  0
>> cgosdrv                17632  0
>> ****************************************************************************************************
>> /etc/modprobe.d/pciehp.conf
>> alias pci:v00001234d00000002sv00001234sd00000001bc11sc80i00 pciehp
>> options pciehp pciehp_force=1 pciehp_debug=1
>> ****************************************************************************************************
>>
>> After I plug my board in,  I executed  echo 1>  /sys/bus/pci/rescan
>

Can you try echo 1 > /sys/bus/pci/slots/XXX/power?
(XXX: slot number)

> It seems like a pciehp bug that you have to rescan explicitly.  But
> I'm not a pciehp expert and I haven't looked at the code.

The pciehp automatically scans the bus on presence changed event
(e.g. board is pluged in) if the hot-plug controller supports
surprise removal. Otherwise, you need to power on slot explicitly
by "echo 1 > /sys/bus/pci/slots/XXX/power". So one possibility is
that your controller doesn't support surprise removal. We can
check it by looking at the pciehp's debug output. Can you send
whole dmesg output?

Regards,
Kenji Kaneshige


>
>>>> * But our software returns : 0xFFFFFFFF
>
> This is reading from your device's memory region.  It looks like the
> device is configured correctly (BAR values are reasonable and memory
> decoding is enabled) and I assume the bridges leading to it are
> configured correctly (if you posted the complete dmesg log we could
> tell for sure).  After that point, Linux is out of the way and it's
> just a question of whether your device responds correctly to the
> memory access.
>
> Are you sure the device is supposed to return something other than
> 0xFFFFFFFF?  If it's memory, can you write to it and read the new
> value back?  Can you use a PCIe analyzer and see if the device is
> responding correctly on the bus?
>
> Other than the possible pciehp rescan problem, this just looks like a
> problem with your FPGA.
>
> Bjorn
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


