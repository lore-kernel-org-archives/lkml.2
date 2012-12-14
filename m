Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab2LNJ5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 04:57:00 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:42265 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab2LNJ45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 04:56:57 -0500
Message-ID: <50CAF7DE.8000203@huawei.com>
Date: Fri, 14 Dec 2012 17:56:46 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH rev.2 0/6] ACPI: Change the ACPI namespace scanning code
 ordering
References: <8498184.VilrUmatxI@vostro.rjw.lan> <1499423.ez5cZl2uAf@vostro.rjw.lan>
In-Reply-To: <1499423.ez5cZl2uAf@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/12/14 6:15, Rafael J. Wysocki wrote:
> Hi All,
> 
> On Sunday, December 09, 2012 11:58:42 PM Rafael J. Wysocki wrote:
>> Hi,
>>
>> The following patches change the ordering of the ACPI namespace scanning code
>> so that all struct acpi_device objects in the given scope are registered before
>> ACPI drivers are probed against them.  They also do some simplifications and
>> clarifications of the code made possible by this main change.
>>
>> This is done for three basic reasons.  First, we need the boot ACPI namespace
>> scanning code to be as similar as reasonably possible to the hot-plug ACPI
>> namespace scanning code.  Second, the ordering of PCI devices enumeration
>> versus ACPI-backed platform devices registration needs to be such that the PCI
>> devices in the given scope are all registered first.  Finally, when we start to
>> actually manage ACPI device resources as appropriate (e.g. resolve resource
>> conflicts properly) we'll need all struct acpi_device nodes to be registered
>> before any "companion" physical nodes or ACPI drivers are bound to them.
>>
>> The patches have been tested on Toshiba Portege R500 without breaking stuff
>> (I used some additional debug code to verify that the ordering of device
>> discovery had not been modified by them), but if you see any problems with
>> them regarding hot-plug, please let me know.
>>
>> [1/6] - Separate adding ACPI device objects from probing ACPI drivers.
>> [2/6] - Change the ordering of PCI root bridge driver registration.
>> [3/6] - Make acpi_bus_add() and acpi_bus_start() visibly different.
>> [4/6] - Reduce the usage of struct acpi_bus_ops
>> [5/6] - Replace struct acpi_bus_ops with an enum type
>> [6/6] - Change the ordering of acpi_bus_check_add() to avoid unnecessary checks.
> 
> The second revision is necessary to address problems found by Yijing Wang
> during testing and explained by Jiang Liu (thanks guys!).
> 
> The problem is that acpi_walk_namespace() doesn't execute the pre_order_visit
> callback for the starting handle, so the callback routine has the be executed
> for it directly, if necessary.
> 
> I also modified a couple of changelogs to better explain the motivation of the
> patches.
> 
> Boot sequence tested on Toshiba Portege R500, but testing on systems with
> hotplug will be appreciated.

Hi rafael,
   I tested this version patchset in my ia64 hotplug machine, and the result looks ok.

Thanks!
Yijing

> 
> Thanks,
> Rafael
> 
> 


-- 
Thanks!
Yijing

