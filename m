Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab1JLGiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 02:38:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58689 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab1JLGiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 02:38:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E953579.6050807@jp.fujitsu.com>
Date: Wed, 12 Oct 2011 15:36:41 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Abdelghani Ouchabane <abdelghani@ezono.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: PCIe can not rescan for new PCIe device ( FPGA board )
References: <4E8EA746.6030103@ezono.com> <CAErSpo6YEp2v9xzVJHsu5WSJDqb+sWZUfS-e7UmGEXENRiWmnQ@mail.gmail.com> <4E8F2758.3040408@ezono.com> <CAErSpo6Lo2bXw=yjscQ6zzRMnpMZ-cUzbBxN3dDS1D3M67sQ8g@mail.gmail.com> <4E939E5D.3010208@jp.fujitsu.com> <4E93FA3D.2030400@ezono.com>
In-Reply-To: <4E93FA3D.2030400@ezono.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

According to your dmesg output, pciehp driver doesn't detect any PCIe
hotplug slot. Can you send the following information?

 - ls -lR /sys/bus/pci/slots
 - lspci -vvvv (as root user)

Regards,
Kenji Kaneshige


(2011/10/11 17:11), Abdelghani Ouchabane wrote:
> 
>>>> After I plug my board in, I executed echo 1> /sys/bus/pci/rescan
>>>
>>>
>>
>> Can you try echo 1 > /sys/bus/pci/slots/XXX/power?
>> (XXX: slot number)
> Hallo Kenji,
> 
> I am still having the same problem after executing "echo 1 > /sys/bus/pci/slots/0000\:02\:00.0/power"
> 
>>
>>> It seems like a pciehp bug that you have to rescan explicitly. But
>>> I'm not a pciehp expert and I haven't looked at the code.
>>
>> The pciehp automatically scans the bus on presence changed event
>> (e.g. board is pluged in) if the hot-plug controller supports
>> surprise removal. Otherwise, you need to power on slot explicitly
>> by "echo 1 > /sys/bus/pci/slots/XXX/power". So one possibility is
>> that your controller doesn't support surprise removal. We can
>> check it by looking at the pciehp's debug output. Can you send
>> whole dmesg output?
> 
> I attached to you the whole dmesg log.
> 
> Cheers,
> Ghani
> 
> 

