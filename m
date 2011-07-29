Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab1G2CWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 22:22:45 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:33982 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab1G2CWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 22:22:44 -0400
X-ASG-Debug-ID: 1311906163-082df4690001-xx1T2L
X-Barracuda-Envelope-From: leoy@marvell.com
Message-ID: <4E3219FE.6020306@marvell.com>
Date: Fri, 29 Jul 2011 10:25:02 +0800
From: Leo Yan <leoy@marvell.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: real mz <realmz6@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>
X-ASG-Orig-Subj: Re: [PATCH] lib/genalloc: fix gen_pool_virt_to_phys locking
Subject: Re: [PATCH] lib/genalloc: fix gen_pool_virt_to_phys locking
References: <1311664741-21336-1-git-send-email-leoy@marvell.com> <CAMk6uBmE01EpAw3e8kB9v6tEkU0rAPqt8T7+k54QDzDxtDn7PQ@mail.gmail.com>
X-ASG-Orig-Subj: Re: [PATCH] lib/genalloc: fix gen_pool_virt_to_phys locking
In-Reply-To: <CAMk6uBmE01EpAw3e8kB9v6tEkU0rAPqt8T7+k54QDzDxtDn7PQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1311906163
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

real mz,

You are right. :-) it's long time not see you guy.
For i am developed based on mainline, so if without this
patch, then the kernel will panic.

Best regards,
Leo Yan


On 2011年07月28日 18:39, real mz wrote:
> this fix seems already on next tree
>
> http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=blob;f=lib/genalloc.c;h=f352cc42f4f8a58b8e4c8304de32cb31b4e29b67;hb=HEAD
>
>
> On Tue, Jul 26, 2011 at 3:19 PM, Leo Yan<leoy@marvell.com>  wrote:
>> The func gen_pool_virt_to_phys will iterate the chunk list;
>> if find the correct chunk it should need release pool's lock.
>>
>> Signed-off-by: Leo Yan<leoy@marvell.com>
>> ---
>>   lib/genalloc.c |    4 +++-
>>   1 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/lib/genalloc.c b/lib/genalloc.c
>> index 577ddf8..e625df5 100644
>> --- a/lib/genalloc.c
>> +++ b/lib/genalloc.c
>> @@ -92,8 +92,10 @@ phys_addr_t gen_pool_virt_to_phys(struct gen_pool *pool, unsigned long addr)
>>         list_for_each(_chunk,&pool->chunks) {
>>                 chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
>>
>> -               if (addr>= chunk->start_addr&&  addr<  chunk->end_addr)
>> +               if (addr>= chunk->start_addr&&  addr<  chunk->end_addr) {
>> +                       read_unlock(&pool->lock);
>>                         return chunk->phys_addr + addr - chunk->start_addr;
>> +               }
>>         }
>>         read_unlock(&pool->lock);
>>
>> --
>> 1.7.4.1
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>
