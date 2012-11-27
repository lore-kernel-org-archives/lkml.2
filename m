Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab2K0LYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 06:24:36 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:26443 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2K0LYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 06:24:34 -0500
Message-ID: <50B4A2D5.2050603@huawei.com>
Date: Tue, 27 Nov 2012 19:24:05 +0800
From: Hanjun Guo <guohanjun@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, <yinghai@kernel.org>,
        <bhelgaas@google.com>, <lenb@kernel.org>, <jiang.liu@huawei.com>,
        <izumi.taku@jp.fujitsu.com>, <linux-acpi@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Wen Congyang <wency@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH v3 0/3] ACPI: container hot remove support.
References: <1351668471-31436-1-git-send-email-tangchen@cn.fujitsu.com> <509106E2.70008@jp.fujitsu.com> <50B3014E.3040107@huawei.com> <50B306E0.3050207@cn.fujitsu.com> <50B4127F.3080400@huawei.com> <50B42798.4030402@cn.fujitsu.com>
In-Reply-To: <50B42798.4030402@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.135.69.25]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/11/27 10:38, Tang Chen wrote:
> On 11/27/2012 09:08 AM, Hanjun Guo wrote:
>> On 2012/11/26 14:06, Tang Chen wrote:
>>> On 11/26/2012 01:42 PM, Hanjun Guo wrote:
>>>>
>>>> Hi all,
>>>> I think Yasuaki mentioned the key point for the container device remove,
>>>> that is dependency.
>>>>
>>>> Currently, container, processor, and memory hotpulg are managed by different ACPI
>>>> hotplug drivers, the driver works when handle device hotplug individually, but they
>>>> have no idea for each other.
>>>>
>>>> This may introduce some issues, such as Yasuaki mentioned above, that is to say, we
>>>> should remove its child before remove the device itself, and hot add its parent before
>>>> the device itself.
>>>>
>>>> According to the ACPI namespace, we can resolve most of dependency issues. On a typical
>>>> two processor sockets system, the namespace is like this:
>>>>
>>>> /_SB                   ---container device, with HID ACPI0004
>>>>       |_SCK0             ---container device, with HID ACPI0004
>>>>        |_CPU0       ---processor device, with HID ACPI0009 or LNXCPU
>>>>             |_...
>>>>             |_CPUx
>>>>             |_MEM0       ---Memory device, with HID PNP0C80
>>>>       |_SCK1
>>>>        |_CPU0
>>>>             |_...
>>>>             |_CPUx
>>>>             |_MEM1
>>>>       |_PCI0            ---Host bridge, with HID PNP0A03 or PNP0A08
>>>>
>>>> If hot remove the container device, such as SCK0, we can easily know the dependency list
>>>> is CPU0~CPUx and MEM0, but I think the ACPI hotplug driver haven't resolve this now.
>>>>
>>>> And there is another corner case for hotplug devices in the namespace above, that is:
>>>> 1) Remove SCK0. yes, we can remove it with no dependency to the host bridge PCI0;
>>>>
>>>> 2) Remove SCK1 after SCK0. we should remove the host bridge PCI0 first,
>>>>      or the system will crash down. yes, dynamic dependency analysis is needed here.
>>>>      and the ACPI hotplug driver totally have no idea of this.
>>>>
>>>> so, should we do something to settle this down ?
>>>
>>> Hi Guo,
>>>
>>> I am trying to do this too. :)
>>
>> Great， what's your idea of this?
>>
> Hi Guo,
> 
> I noticed they had a lot of discussion on this topic.
> https://lkml.org/lkml/2012/11/15/159
> 
> And Vasilis's latest patches are here:
> https://lkml.org/lkml/2012/11/23/335
> 
> I think we can have a review of this patchset first. :)

Hi Tang,
Thanks for your remind, I will review Vasilis's latest patches,
and reply Vasilis's patch if I have any comments.

> 
> And also, as you said, the new ACPI hotplug framework from Liu Jiang
> will settle this problem more properly.
> So I think any solution now could be temporary. :)
> 
> .
> 


