Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab2ACVcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 16:32:52 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:42532 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab2ACVcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 16:32:51 -0500
Message-ID: <4F03739F.4080000@ah.jp.nec.com>
Date: Tue, 03 Jan 2012 16:31:11 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Organization: NEC Corporation
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.25) Gecko/20111213 Thunderbird/3.1.17
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: kosaki.motohiro@gmail.com, linux-mm@kvack.org, akpm@linux-foundation.org,
        rientjes@google.com, andi@firstfloor.org, fengguang.wu@intel.com,
        aarcange@redhat.com, kamezawa.hiroyu@jp.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] pagemap: avoid splitting thp when reading /proc/pid/pagemap
References: <1324506228-18327-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1324506228-18327-2-git-send-email-n-horiguchi@ah.jp.nec.com> <4EFD3266.4080701@gmail.com> <4F035FF6.7020206@ah.jp.nec.com> <4F036DD4.2060709@jp.fujitsu.com>
In-Reply-To: <4F036DD4.2060709@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(1/3/2012 16:06), KOSAKI Motohiro wrote:
> On 1/3/2012 3:07 PM, Naoya Horiguchi wrote:
>> On Thu, Dec 29, 2011 at 10:39:18PM -0500, KOSAKI Motohiro wrote:
>> ...
>>>> --- 3.2-rc5.orig/fs/proc/task_mmu.c
>>>> +++ 3.2-rc5/fs/proc/task_mmu.c
>>>> @@ -600,6 +600,9 @@ struct pagemapread {
>>>>   	u64 *buffer;
>>>>   };
>>>>
>>>> +#define PAGEMAP_WALK_SIZE	(PMD_SIZE)
>>>> +#define PAGEMAP_WALK_MASK	(PMD_MASK)
>>>> +
>>>>   #define PM_ENTRY_BYTES      sizeof(u64)
>>>>   #define PM_STATUS_BITS      3
>>>>   #define PM_STATUS_OFFSET    (64 - PM_STATUS_BITS)
>>>> @@ -658,6 +661,22 @@ static u64 pte_to_pagemap_entry(pte_t pte)
>>>>   	return pme;
>>>>   }
>>>>
>>>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>>> +static u64 thp_pte_to_pagemap_entry(pte_t pte, int offset)
>>>> +{
>>>> +	u64 pme = 0;
>>>> +	if (pte_present(pte))
>>>
>>> When does pte_present() return 0?
>>
>> It does when the page pointed to by pte is swapped-out, under page migration,
>> or HWPOISONed. But currenly it can't happen on thp because thp will be
>> splitted before these operations are processed.
>> So this if-sentense is not necessary for now, but I think it's not a bad idea
>> to put it now to prepare for future implementation.
> 
> You certainly need to add a comment. otherwise you add *unnecessary* complexity
> and people is going to be puzzled.

OK, I care about that.
Thank you.
