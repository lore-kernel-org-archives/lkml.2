Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab2HGJHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 05:07:00 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46838 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab2HGJG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 05:06:59 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5020D9B3.7020506@jp.fujitsu.com>
Date: Tue, 07 Aug 2012 18:02:43 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: vgoyal@redhat.com
CC: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com, hbabu@us.ibm.com,
        ishii.hironobu@jp.fujitsu.com, martin.wilck@ts.fujitsu.com
Subject: Re: [RFC][PATCH] Reset PCIe devices to address DMA problem on kdump
 with iommu
References: <501BB4EF.7080909@jp.fujitsu.com> <20120803114643.GA28330@redhat.com> <501F4877.5050605@jp.fujitsu.com> <20120806203902.GH25559@redhat.com>
In-Reply-To: <20120806203902.GH25559@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/08/07 5:39), Vivek Goyal wrote:
> On Mon, Aug 06, 2012 at 01:30:47PM +0900, Takao Indoh wrote:
>> Hi Vivek,
>>
>> (2012/08/03 20:46), Vivek Goyal wrote:
>>> On Fri, Aug 03, 2012 at 08:24:31PM +0900, Takao Indoh wrote:
>>>> Hi all,
>>>>
>>>> This patch adds kernel parameter "reset_pcie_devices" which resets PCIe
>>>> devices at boot time to address DMA problem on kdump with iommu. When
>>>> this parameter is specified, a hot reset is triggered on each PCIe root
>>>> port and downstream port to reset its downstream endpoint.
>>>
>>> Hi Takao,
>>>
>>> Why not use existing "reset_devices" parameter instead of introducing
>>> a new one?
>>
>> "reset_devices" is used for each driver to reset their own device, and
>> this patch resets all devices forcibly, so I thought they were different
>> things.
>
> Yes reset_devices currently is used for driver to reset its device. I
> thought one could very well extend its reach to reset pci express devices
> at bus level.
>
> Having them separate is not going to be much useful from kdump
> perspective. We will end up passing both reset_devices and
> reset_pcie_devices to second kernel whill lead to bus level reset as well
> as device level reset.
>
> Ideal situation would be that somehow detect that bus level reset has been
> done and skip device level reset (assuming bus level reset obviates the
> need of device level reset, please correct me if that's not the case).
>
> After pcie reset, can we store the state in a variable and drivers can
> use that variable to check if PCIe level reset was done or not. If yes,
> skip device level reset (Assuming driver knows that device is on a
> PCIe slot).
>
> In that case we will not have to introduce new kernel command line, and
> also avoid double reset?

Actually I'm not sure whether the driver does not need to do their reset after
bus level reset, but I agree with you, now I'm thinking that using reset_devices
is better rather than adding narrow one which is limited to PCI express, otherwise
we may have to add new parameter every time when adding new reset method, such as
reset_pcie_devices, reset_pci_legacy_devices, etc.

Thanks,
Takao Indoh

