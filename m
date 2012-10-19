Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab2JSH3b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 03:29:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:20277 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab2JSH3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 03:29:30 -0400
X-IronPort-AV: E=Sophos;i="4.80,612,1344182400"; 
   d="scan'208";a="6029661"
Message-ID: <508102A8.1050605@cn.fujitsu.com>
Date: Fri, 19 Oct 2012 15:35:04 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, cl@linux.com, minchan.kim@gmail.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/4] acpi,memory-hotplug : add memory offline code to
 acpi_memory_device_remove()
References: <506C0AE8.40702@jp.fujitsu.com> <506C0C53.60205@jp.fujitsu.com> <CAHGf_=p7PaQs-kpnyB8uC1MntHQfL-CXhhq4QQP54mYiqOswqQ@mail.gmail.com> <50727984.20401@cn.fujitsu.com> <CAHGf_=pCrx8AkL9eiSYVgwvT1v0SW2__P_DW-1Wwj_zskqcLXw@mail.gmail.com> <507E54AA.2080806@cn.fujitsu.com> <CAHGf_=o_Wu1kr56C=7XTjYRzL4egSyGJYd4+2RecVWzpeM427Q@mail.gmail.com> <507E75AA.2000605@cn.fujitsu.com> <CAHGf_=oNufcAQhxWtvq56qwF==+14+Cm7r9eiTGdY=B=ENwPQg@mail.gmail.com> <507E7FC2.8@cn.fujitsu.com> <507F5A78.7030500@jp.fujitsu.com>
In-Reply-To: <507F5A78.7030500@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 15:29:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 15:29:04,
	Serialize complete at 2012/10/19 15:29:04
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 10/18/2012 09:25 AM, Yasuaki Ishimatsu Wrote:
> Hi Wen,
> 
> 2012/10/17 18:52, Wen Congyang wrote:
>> At 10/17/2012 05:18 PM, KOSAKI Motohiro Wrote:
>>>>>>>> Hmm, it doesn't move the code. It just reuse the code in
>>>>>>>> acpi_memory_powerdown_device().
>>>>>>>
>>>>>>> Even if reuse or not reuse, you changed the behavior. If any changes
>>>>>>> has no good rational, you cannot get an ack.
>>>>>>
>>>>>> I don't understand this? IIRC, the behavior isn't changed.
>>>>>
>>>>> Heh, please explain why do you think so.
>>>>
>>>> We just introduce a function, and move codes from
>>>> acpi_memory_disable_device() to the new
>>>> function. We call the new function in acpi_memory_disable_device(),
>>>> so the function
>>>> acpi_memory_disable_device()'s behavior isn't changed.
>>>>
>>>> Maybe I don't understand what do you want to say.
>>>
>>> Ok, now you agreed you moved the code, yes? So then, you should
>>> explain why
>>> your code moving makes zero impact other acpi_memory_disable_device()
>>> caller.
>>
>> We just move the code, and don't change the
>> acpi_memory_disable_device()'s behavior.
>>
>> I look it the change again, and found some diffs:
>> 1. we treat !info->enabled as error, while it isn't a error without
>> this patch
>> 2. we remove memory info from the list, it is a bug fix because we
>> free the memory
>>     that stores memory info.(I have sent a patch to fix this bug, and
>> it is in akpm's tree now)
>>
>> I guess you mean 1 will change the behavior. In the last version, I
>> don't do it.
>> Ishimatsu changes this and I don't notify this.
>>
>> To Ishimatsu:
>>
>> Why do you change this?
> 
> Oops. If so, it's my mistake.
> Could you update it in next version?

OK

Thanks
Wen Congyang

> 
> Thanks,
> Yasuaki Ishimatsu
> 
>>
>> Thanks
>> Wen Congyang
>>
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

