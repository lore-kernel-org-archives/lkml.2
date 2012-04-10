Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab2DJQFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 12:05:46 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37151 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab2DJQFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 12:05:43 -0400
Message-ID: <4F845A4E.90003@gmail.com>
Date: Wed, 11 Apr 2012 00:05:34 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/2] PCI, ACPI, x86: update MMCFG information when hot-plugging
 PCI host bridges
References: <1333905129-8776-1-git-send-email-jiang.liu@huawei.com> <1333905129-8776-3-git-send-email-jiang.liu@huawei.com> <4F82CB64.8030808@jp.fujitsu.com> <4F830804.6010007@gmail.com> <4F840C3C.2060302@jp.fujitsu.com> <CAE9FiQWZwkyp8F7HDTpGVZ=Q=09_68NR3tT_vCzwFH3ZhXDzCA@mail.gmail.com>
In-Reply-To: <CAE9FiQWZwkyp8F7HDTpGVZ=Q=09_68NR3tT_vCzwFH3ZhXDzCA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 11:47 PM, Yinghai Lu wrote:
> On Tue, Apr 10, 2012 at 3:32 AM, Kenji Kaneshige
> <kaneshige.kenji@jp.fujitsu.com> wrote:
>> Additionally, I think there is a remaining issue even if we change
>> this check like below.
>>
>>
>>        if (!!(pci_probe & PCI_PROBE_MASK & ~PCI_PROBE_MMCONF))
>>                return 0;
>>
>> I think this check has an assumption that system has at least one
>> MCFG table entry and it has been initialized before
>> acpi_pci_root_add() is called. I think this doesn't work on the
>> system that doesn't have MCFG and all the pci root bridge have
>> _CBA (that is, all host bridges are hot-pluggable and BIOS is
>> implemented in the way PCI FW spec defines). As a result, MMCONFIG
>> would never be enabled on such systems. Could you double check this?
> 
> You are right.
> 
> We can just remove that checking.
> 
> But wonder if current x86_64 system support that.
> All peer root buses can be physically removed ?
It's theoretically possible that BIOS doesn't provide MMCFG or _CBA
for the legacy (non-removable bus 0) host bridge. 

> 
> Thanks
> 
> Yinghai

