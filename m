Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab2HBHJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 03:09:22 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:16483 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab2HBHJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 03:09:21 -0400
Message-ID: <501A2740.3000309@huawei.com>
Date: Thu, 2 Aug 2012 15:07:44 +0800
From: Jiang Liu <jiang.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>
CC: Jiang Liu <liuj97@gmail.com>, Len Brown <lenb@kernel.org>,
        Tony Luck <tony.luch@intel.com>, Bob Moore <robert.moore@intel.com>,
        Huang Ying <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Hanjun Guo <guohanjun@huawei.com>,
        <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, Gaohuai Han <hangaohuai@huawei.com>
Subject: Re: [RFC PATCH 1/3] ACPIHP: introduce a framework for ACPI based
 system device hotplug
References: <1343475772-21345-1-git-send-email-jiang.liu@huawei.com> <1343475772-21345-2-git-send-email-jiang.liu@huawei.com> <501A271A.5030808@cn.fujitsu.com>
In-Reply-To: <501A271A.5030808@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.108.108.229]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-8-2 15:07, Tang Chen wrote:
> Hi,
> 
> A little problem here. :)
> 
> On 07/28/2012 07:42 PM, Jiang Liu wrote:
>> +int acpihp_register_slot(struct acpihp_slot *slot)
>> +{
>> +	int ret;
>> +	char *name;
>> +	size_t off;
>> +
>> +	if (!slot || !slot->slot_ops)
>> +		return -EINVAL;
>> +
>> +	/* Hook top level hotplug slots under ACPI root device */
>> +	if (slot->parent)
>> +		slot->dev.parent = &slot->parent->dev;
>> +	else
>> +		slot->dev.parent = &acpi_root->dev;
>> +
>> +	ret = device_add(&slot->dev);
>> +	if (!ret) {
>> +		slot->flags |= ACPIHP_SLOT_FLAG_REGISTERED;
>> +		name = kmalloc(PAGE_SIZE, GFP_KERNEL);
>> +		if (name) {
>> +			off = acpihp_generate_link_name(slot, name, 0);
>> +			name[off - 1] = '\0';
>> +			sysfs_create_link(&acpihp_slot_kset->kobj,
>> +					  &slot->dev.kobj, name);
> 
> I got a compiler warning here:
>   CC      drivers/acpi/hotplug/core.o
> drivers/acpi/hotplug/core.c: In function ‘acpihp_register_slot’:
> drivers/acpi/hotplug/core.c:199: warning: ignoring return value of ‘sysfs_create_link’, declared with attribute warn_unused_result
> 
> Seems that we need to check the sysfs_create_link()'s return value here, and if it fails, 
> shall we at least give a warning message here ?
> 
> Thanks. :)
Hi Tang,
	Thanks for your comments, will fix it in next version.
	Regards!
	Gerry

> 
> 
>> +			kfree(name);
>> +		}
>> +	}
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(acpihp_register_slot);
> 


