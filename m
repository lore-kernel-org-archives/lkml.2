Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378Ab2JQI7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 04:59:44 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:37382 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab2JQI7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 04:59:43 -0400
MIME-Version: 1.0
In-Reply-To: <507E54AA.2080806@cn.fujitsu.com>
References: <506C0AE8.40702@jp.fujitsu.com> <506C0C53.60205@jp.fujitsu.com>
 <CAHGf_=p7PaQs-kpnyB8uC1MntHQfL-CXhhq4QQP54mYiqOswqQ@mail.gmail.com>
 <50727984.20401@cn.fujitsu.com> <CAHGf_=pCrx8AkL9eiSYVgwvT1v0SW2__P_DW-1Wwj_zskqcLXw@mail.gmail.com>
 <507E54AA.2080806@cn.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Wed, 17 Oct 2012 04:59:22 -0400
X-Google-Sender-Auth: NSTnBjmG0GoCjB4hIs_Nh7hEx5s
Message-ID: <CAHGf_=o_Wu1kr56C=7XTjYRzL4egSyGJYd4+2RecVWzpeM427Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] acpi,memory-hotplug : add memory offline code to acpi_memory_device_remove()
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, cl@linux.com, minchan.kim@gmail.com,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 2:48 AM, Wen Congyang <wency@cn.fujitsu.com> wrote:
> At 10/13/2012 03:10 AM, KOSAKI Motohiro Wrote:
>>>>> -static int acpi_memory_disable_device(struct acpi_memory_device *mem_device)
>>>>> +static int acpi_memory_remove_memory(struct acpi_memory_device *mem_device)
>>>>>  {
>>>>>         int result;
>>>>>         struct acpi_memory_info *info, *n;
>>>>>
>>>>> +       list_for_each_entry_safe(info, n, &mem_device->res_list, list) {
>>>>
>>>> Which lock protect this loop?
>>>
>>> There is no any lock to protect it now...
>>
>> When iterate an item removal list, you should use lock for protecting from
>> memory corruption.
>>
>>
>>
>>
>>>>> +static int acpi_memory_disable_device(struct acpi_memory_device *mem_device)
>>>>> +{
>>>>> +       int result;
>>>>>
>>>>>         /*
>>>>>          * Ask the VM to offline this memory range.
>>>>>          * Note: Assume that this function returns zero on success
>>>>>          */
>>>>
>>>> Write function comment instead of this silly comment.
>>>>
>>>>> -       list_for_each_entry_safe(info, n, &mem_device->res_list, list) {
>>>>> -               if (info->enabled) {
>>>>> -                       result = remove_memory(info->start_addr, info->length);
>>>>> -                       if (result)
>>>>> -                               return result;
>>>>> -               }
>>>>> -               kfree(info);
>>>>> -       }
>>>>> +       result = acpi_memory_remove_memory(mem_device);
>>>>> +       if (result)
>>>>> +               return result;
>>>>>
>>>>>         /* Power-off and eject the device */
>>>>>         result = acpi_memory_powerdown_device(mem_device);
>>>>
>>>> This patch move acpi_memory_powerdown_device() from ACPI_NOTIFY_EJECT_REQUEST
>>>> to release callback, but don't explain why.
>>>
>>> Hmm, it doesn't move the code. It just reuse the code in acpi_memory_powerdown_device().
>>
>> Even if reuse or not reuse, you changed the behavior. If any changes
>> has no good rational, you cannot get an ack.
>
> I don't understand this? IIRC, the behavior isn't changed.

Heh, please explain why do you think so.
