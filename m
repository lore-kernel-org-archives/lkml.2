Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab2IQOWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 10:22:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65282 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756458Ab2IQOWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 10:22:53 -0400
Message-ID: <50573232.9080508@gmail.com>
Date: Mon, 17 Sep 2012 22:22:42 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Jiang Liu <jiang.liu@huawei.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 5/9] ACPI/pci-bind: remove bind/unbind callbacks from
 acpi_device_ops
References: <1347678312-11124-1-git-send-email-jiang.liu@huawei.com> <1347678312-11124-6-git-send-email-jiang.liu@huawei.com> <CAE9FiQWk_2gPyVUiLgvRQ=qrFNby_R7Qh-QNruobQnhVFTn21w@mail.gmail.com> <CAE9FiQX2hgxQo3GC3_0h5D5uo9coRZqcpPCKGtzF7jYbUfvxUw@mail.gmail.com>
In-Reply-To: <CAE9FiQX2hgxQo3GC3_0h5D5uo9coRZqcpPCKGtzF7jYbUfvxUw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2012 11:03 AM, Yinghai Lu wrote:
> On Sat, Sep 15, 2012 at 4:27 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Fri, Sep 14, 2012 at 8:05 PM, Jiang Liu <liuj97@gmail.com> wrote:
>>>  From: Jiang Liu <jiang.liu@huawei.com>
>>>
>>> Now ACPI devices are created before/destroyed after corresponding PCI
>>> devices, and acpi_platform_notify/acpi_platform_notify_remove will
>>> update PCI<->ACPI binding relationship when creating/destroying PCI
>>> devices, there's no need to invoke bind/unbind callbacks from ACPI
>>> device probe/destroy routines anymore. So remove bind/unbind callbacks
>>> from acpi_device_ops.
>> for pci root bus, acpi_bus_trim() is used to remove acpi_device.
>>
>> and later in acpi_pci_root_remove to stop pci drivers/ioapic driver,
>> iommu driver then remove pci devices.
>>
>> if call back is removed there, then could some functions in
>> acpi_pci_unbind() will be skipped.
>>
>> I really do not want to add pci_stop_bus_devices() in
>> pci_root_hp.c::handle_root_bridge_removal before
>> calling acpi_bus_trim...
> 
> FYI, I solved the problem.  will call apci_bus_remove() two times. it
> will make sure pci devices
> get removed at first before acpi devices...
Hi Yinghai,
	Great! So we could remove the acpi<->PCI logic now.
	Thanks!
	Gerry

