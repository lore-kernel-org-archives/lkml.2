Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab2HBHFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 03:05:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59665 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753879Ab2HBHFP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 03:05:15 -0400
X-IronPort-AV: E=Sophos;i="4.77,699,1336320000"; 
   d="scan'208";a="5535514"
Message-ID: <501A271A.5030808@cn.fujitsu.com>
Date: Thu, 02 Aug 2012 15:07:06 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Len Brown <lenb@kernel.org>, Tony Luck <tony.luch@intel.com>,
        Bob Moore <robert.moore@intel.com>, Huang Ying <ying.huang@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Hanjun Guo <guohanjun@huawei.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        Gaohuai Han <hangaohuai@huawei.com>
Subject: Re: [RFC PATCH 1/3] ACPIHP: introduce a framework for ACPI based
 system device hotplug
References: <1343475772-21345-1-git-send-email-jiang.liu@huawei.com> <1343475772-21345-2-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1343475772-21345-2-git-send-email-jiang.liu@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/02 15:05:43,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/02 15:05:44
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A little problem here. :)

On 07/28/2012 07:42 PM, Jiang Liu wrote:
> +int acpihp_register_slot(struct acpihp_slot *slot)
> +{
> +	int ret;
> +	char *name;
> +	size_t off;
> +
> +	if (!slot || !slot->slot_ops)
> +		return -EINVAL;
> +
> +	/* Hook top level hotplug slots under ACPI root device */
> +	if (slot->parent)
> +		slot->dev.parent = &slot->parent->dev;
> +	else
> +		slot->dev.parent = &acpi_root->dev;
> +
> +	ret = device_add(&slot->dev);
> +	if (!ret) {
> +		slot->flags |= ACPIHP_SLOT_FLAG_REGISTERED;
> +		name = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +		if (name) {
> +			off = acpihp_generate_link_name(slot, name, 0);
> +			name[off - 1] = '\0';
> +			sysfs_create_link(&acpihp_slot_kset->kobj,
> +					  &slot->dev.kobj, name);

I got a compiler warning here:
  CC      drivers/acpi/hotplug/core.o
drivers/acpi/hotplug/core.c: In function ‘acpihp_register_slot’:
drivers/acpi/hotplug/core.c:199: warning: ignoring return value of ‘sysfs_create_link’, declared with attribute warn_unused_result

Seems that we need to check the sysfs_create_link()'s return value here, and if it fails, 
shall we at least give a warning message here ?

Thanks. :)


> +			kfree(name);
> +		}
> +	}
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(acpihp_register_slot);

-- 
Best Regards,
Tang chen
