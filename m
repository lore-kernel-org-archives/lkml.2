Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab2KABuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 21:50:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:31794 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754763Ab2KABuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 21:50:05 -0400
X-IronPort-AV: E=Sophos;i="4.80,690,1344182400"; 
   d="scan'208";a="6111795"
Message-ID: <5091D504.7010607@cn.fujitsu.com>
Date: Thu, 01 Nov 2012 09:48:52 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, bhelgaas@google.com,
        lenb@kernel.org, jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] ACPI: container hot remove support.
References: <1351668471-31436-1-git-send-email-tangchen@cn.fujitsu.com> <509106E2.70008@jp.fujitsu.com> <CAE9FiQVrMj2KunOMDvftnu=MG=t=UpKTA4-t_YTYdgVL-rg_7Q@mail.gmail.com>
In-Reply-To: <CAE9FiQVrMj2KunOMDvftnu=MG=t=UpKTA4-t_YTYdgVL-rg_7Q@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/01 09:49:19,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/01 09:49:19,
	Serialize complete at 2012/11/01 09:49:19
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,

How do you think the 1st patch ? Is the idea OK with you ?

And about the memory hotplug thing, so far as I know, we are trying to
limit kernel memory in some nodes, and only support to hot-remove the
nodes with out kernel memory. This functionality is called
online_movable. And some of the patches are already in next-tree, most
of the patches are under review. :)

Thanks. :)

On 11/01/2012 12:48 AM, Yinghai Lu wrote:
> On Wed, Oct 31, 2012 at 4:09 AM, Yasuaki Ishimatsu
> <isimatu.yasuaki@jp.fujitsu.com>  wrote:
>>> patch 2. Introduce a new function container_device_remove() to handle
>>>            ACPI_NOTIFY_EJECT_REQUEST event for container.
>>
>> If container device contains memory device, the function is
>> very danger. As you know, we are developing a memory hotplug.
>> If memory has kernel memory, memory hot remove operations fails.
>> But container_device_remove() cannot realize it. So even if
>> the memory hot remove operation fails, container_device_remove()
>> keeps hot remove operation. Finally, the function sends _EJ0
>> to firmware. In this case, if the memory is accessed, kernel
>> panic occurs.
>> The example is as follows:
>>
>>   https://lkml.org/lkml/2012/9/26/318
>
> so what is the overall status memory hot-remove?
> how are following memory get processed ?
> 1. memory for kernel text, module
> 2. page table
> 3. vmemmap
> 4. memory for kmalloc, for dma
>

