Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab1BPWrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:47:14 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38533 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab1BPWrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:47:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=PVr+3R7IRrH/+ow5TJbOk0+u7WM6LErxVvEdXNVitzBTbogiiQvYDhgVxJ97nUyqf8
         HDSoBPEvXv6fUD57B7sILm2uDn0VYkX03RAGToMLMhv4SsDr0CPiNgdbFIWafvqBCi9n
         tca6yQx7Ii8/sYcsw+L0B68L9PoqLcrw3zcmM=
Message-ID: <4D5C53EB.5040505@gmail.com>
Date: Thu, 17 Feb 2011 01:47:07 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, numa: seperate alloc_numa_distance from numa_reset_distance.
References: <4D5C3A0F.3080107@kernel.org> <4D5C3A40.1060106@kernel.org> <4D5C4538.7060403@gmail.com> <4D5C4FD7.5070603@kernel.org>
In-Reply-To: <4D5C4FD7.5070603@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2011 01:29 AM, Yinghai Lu wrote:
> On 02/16/2011 01:44 PM, Cyrill Gorcunov wrote:
>> On 02/16/2011 11:57 PM, Yinghai Lu wrote:
>>>
>>> alloc code is much bigger the setting self.
>>>
>> ...
>>> +
>>> +    numa_distance = __va(phys);
>>> +    numa_distance_cnt = cnt;
>>> +
>>> +    /* fill with the default distances */
>>> +    for (i = 0; i<   cnt; i++)
>>> +        for (j = 0; j<   cnt; j++)
>>> +            numa_distance[i * cnt + j] = i == j ?
>>> +                LOCAL_DISTANCE : REMOTE_DISTANCE;
>>> +    printk(KERN_DEBUG "NUMA: Initialized distance table, cnt=%d\n",
>>> cnt);
>>> +}
>>> +
>>
>>    Hi Yinghai, btw would it be convenient to use node_distance() helper here
>> (since this snippet is touched anyway and there is a big merging of numa
>>   code), ie
>>
>>      /* fill with the default distances */
>>      for (i = 0; i<  cnt; i++)
>>          for (j = 0; j<   cnt; j++)
>>              numa_distance[i * cnt + j] = node_distance(i, j);
>>
>> though it should be patch on top of yours to not mix with plain code move
>
> do you mean
>
> int __node_distance(int from, int to)
> {
>          if (from>= numa_distance_cnt || to>= numa_distance_cnt)
>                  return from == to ? LOCAL_DISTANCE : REMOTE_DISTANCE;
>          return numa_distance[from * numa_distance_cnt + to];
> }
> EXPORT_SYMBOL(__node_distance);
>
> or node_distance()?
>
> then you will have
>
>   numa_distance[i * cnt + j] =  numa_distance[i * cnt + j];
>
> ...

Ah, yeah, I mentally swapped >= to <= which is not true of course,
drop this idea, sorry.

-- 
     Cyrill
