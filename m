Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab1JUBhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 21:37:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:14860 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab1JUBhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 21:37:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="65374637"
Message-ID: <4EA0CCE5.3060207@linux.intel.com>
Date: Fri, 21 Oct 2011 09:37:41 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: qemulist@gmail.com
CC: Gong Chen <clumsycg@gmail.com>, pingfank@linux.vnet.ibm.com,
        aliguori@us.ibm.com, seabios@seabios.org, qemu-devel@nongnu.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        shaohua.li@intel.com, dave@linux.vnet.ibm.com, lenb@kernel.org
Subject: Re: [Qemu-devel] [PATCH 1/1] ACPI: Call ACPI remove handler when
 handling ACPI eject event
References: <1318992470-10195-1-git-send-email-pingfank@linux.vnet.ibm.com> <1318992470-10195-2-git-send-email-pingfank@linux.vnet.ibm.com> <CAMJ_OhjLvsZ3Vir3hVX2Ha+jA-ORX=3PBapY=B+aZP-ynqbB6A@mail.gmail.com> <20111020093730.GA18393@oc8440477808.ibm.com>
In-Reply-To: <20111020093730.GA18393@oc8440477808.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011/10/20 17:37, qemulist@gmail.com 写道:
> On Wed, Oct 19, 2011 at 09:35:46PM +0800, Gong Chen wrote:
>> On Wed, Oct 19, 2011 at 10:47 AM,<pingfank@linux.vnet.ibm.com>  wrote:
>>> From: Liu Ping Fan<pingfank@linux.vnet.ibm.com>
>>>
>>> Call the remove handler for ACPI_NOTIFY_EJECT_REQUEST
>>>
>>> Signed-off-by: Liu Ping Fan<pingfank@linux.vnet.ibm.com>
>>> ---
>>>   drivers/acpi/bus.c      |    2 +-
>>>   drivers/acpi/scan.c     |    2 +-
>>>   include/acpi/acpi_bus.h |    2 ++
>>>   3 files changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
>>> index 437ddbf..d06ec6d 100644
>>> --- a/drivers/acpi/bus.c
>>> +++ b/drivers/acpi/bus.c
>>> @@ -764,7 +764,7 @@ static void acpi_bus_notify(acpi_handle handle, u32 type, void *data)
>>>                 break;
>>>
>>>         case ACPI_NOTIFY_EJECT_REQUEST:
>>> -               /* TBD */
>>> +               acpi_os_hotplug_execute(acpi_bus_hot_remove_device, handle);
>>>                 break;
>>>
>>>         case ACPI_NOTIFY_DEVICE_CHECK_LIGHT:
>>> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
>>> index 449c556..3b97b61 100644
>>> --- a/drivers/acpi/scan.c
>>> +++ b/drivers/acpi/scan.c
>>> @@ -83,7 +83,7 @@ acpi_device_modalias_show(struct device *dev, struct device_attribute *attr, cha
>>>   }
>>>   static DEVICE_ATTR(modalias, 0444, acpi_device_modalias_show, NULL);
>>>
>>> -static void acpi_bus_hot_remove_device(void *context)
>>> +void acpi_bus_hot_remove_device(void *context)
>>>   {
>>>         struct acpi_device *device;
>>>         acpi_handle handle = context;
>>> diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
>>> index 6cd5b64..b19c09d 100644
>>> --- a/include/acpi/acpi_bus.h
>>> +++ b/include/acpi/acpi_bus.h
>>> @@ -310,6 +310,8 @@ extern int unregister_acpi_notifier(struct notifier_block *);
>>>
>>>   extern int register_acpi_bus_notifier(struct notifier_block *nb);
>>>   extern void unregister_acpi_bus_notifier(struct notifier_block *nb);
>>> +extern void acpi_bus_hot_remove_device(void *context);
>>> +
>>>   /*
>>>   * External Functions
>>>   */
>>> --
>>> 1.7.4.4
>>>
>>
>> I preferred the patch from Shen before. Here is the link:
>> https://lkml.org/lkml/2011/9/24/15
>> As Bjorn said, "long-term goal to move the hotplug flow out of drivers and into
>> the ACPI core". An arbitrary change in the global level just mess up the codes.
> Got it, thanks. And so will this feature emerge in upstream soon?
>
> Thanks and regards,
> pingfan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

It's up to the maintainer, should be Len Brown :-)
