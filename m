Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab2JRBZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 21:25:51 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39846 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab2JRBZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 21:25:49 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <507F5A78.7030500@jp.fujitsu.com>
Date: Thu, 18 Oct 2012 10:25:12 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, <x86@kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linux-acpi@vger.kernel.org>, <rientjes@google.com>,
        <liuj97@gmail.com>, <len.brown@intel.com>, <cl@linux.com>,
        <minchan.kim@gmail.com>, <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] acpi,memory-hotplug : add memory offline code to
 acpi_memory_device_remove()
References: <506C0AE8.40702@jp.fujitsu.com> <506C0C53.60205@jp.fujitsu.com> <CAHGf_=p7PaQs-kpnyB8uC1MntHQfL-CXhhq4QQP54mYiqOswqQ@mail.gmail.com> <50727984.20401@cn.fujitsu.com> <CAHGf_=pCrx8AkL9eiSYVgwvT1v0SW2__P_DW-1Wwj_zskqcLXw@mail.gmail.com> <507E54AA.2080806@cn.fujitsu.com> <CAHGf_=o_Wu1kr56C=7XTjYRzL4egSyGJYd4+2RecVWzpeM427Q@mail.gmail.com> <507E75AA.2000605@cn.fujitsu.com> <CAHGf_=oNufcAQhxWtvq56qwF==+14+Cm7r9eiTGdY=B=ENwPQg@mail.gmail.com> <507E7FC2.8@cn.fujitsu.com>
In-Reply-To: <507E7FC2.8@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wen,

2012/10/17 18:52, Wen Congyang wrote:
> At 10/17/2012 05:18 PM, KOSAKI Motohiro Wrote:
>>>>>>> Hmm, it doesn't move the code. It just reuse the code in acpi_memory_powerdown_device().
>>>>>>
>>>>>> Even if reuse or not reuse, you changed the behavior. If any changes
>>>>>> has no good rational, you cannot get an ack.
>>>>>
>>>>> I don't understand this? IIRC, the behavior isn't changed.
>>>>
>>>> Heh, please explain why do you think so.
>>>
>>> We just introduce a function, and move codes from acpi_memory_disable_device() to the new
>>> function. We call the new function in acpi_memory_disable_device(), so the function
>>> acpi_memory_disable_device()'s behavior isn't changed.
>>>
>>> Maybe I don't understand what do you want to say.
>>
>> Ok, now you agreed you moved the code, yes? So then, you should explain why
>> your code moving makes zero impact other acpi_memory_disable_device() caller.
>
> We just move the code, and don't change the acpi_memory_disable_device()'s behavior.
>
> I look it the change again, and found some diffs:
> 1. we treat !info->enabled as error, while it isn't a error without this patch
> 2. we remove memory info from the list, it is a bug fix because we free the memory
>     that stores memory info.(I have sent a patch to fix this bug, and it is in akpm's tree now)
>
> I guess you mean 1 will change the behavior. In the last version, I don't do it.
> Ishimatsu changes this and I don't notify this.
>
> To Ishimatsu:
>
> Why do you change this?

Oops. If so, it's my mistake.
Could you update it in next version?

Thanks,
Yasuaki Ishimatsu

>
> Thanks
> Wen Congyang
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


