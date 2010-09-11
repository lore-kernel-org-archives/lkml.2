Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab0IKCKB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 22:10:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab0IKCKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 22:10:00 -0400
Message-ID: <4C8AE4DC.3030308@redhat.com>
Date: Fri, 10 Sep 2010 22:09:32 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 1/4] hugetlb, rmap: always use anon_vma root pointer
References: <1284092586-1179-1-git-send-email-n-horiguchi@ah.jp.nec.com>	<1284092586-1179-2-git-send-email-n-horiguchi@ah.jp.nec.com>	<AANLkTikV9nXxMW8X9Wq+wGaJfzMEAmzTFrDNf8Aq4cTs@mail.gmail.com> <20100910235022.74ec04de@basil.nowhere.org>
In-Reply-To: <20100910235022.74ec04de@basil.nowhere.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2010 05:50 PM, Andi Kleen wrote:
> On Fri, 10 Sep 2010 10:19:24 -0700
> Linus Torvalds<torvalds@linux-foundation.org>  wrote:
>
>> On Thu, Sep 9, 2010 at 9:23 PM, Naoya Horiguchi
>> <n-horiguchi@ah.jp.nec.com>  wrote:
>>> This patch applies Andrea's fix given by the following patch into
>>> hugepage rmapping code:
>>>
>>>   commit 288468c334e98aacbb7e2fb8bde6bc1adcd55e05
>>>   Author: Andrea Arcangeli<aarcange@redhat.com>
>>>   Date:   Mon Aug 9 17:19:09 2010 -0700
>>>
>>> This patch uses anon_vma->root and avoids unnecessary overwriting
>>> when anon_vma is already set up.
>>
>> Btw, why isn't the code in __page_set_anon_rmap() also doing this
>> cleaner version (ie a single "if (PageAnon(page)) return;" up front)?
>
> Perhaps I misunderstand the question, but __page_set_anon_rmap
> should handle Anon pages, shouldn't it?

__page_set_anon_rmap sets the page->mapping to be
a pointer to the anon_vma & PAGE_MAPPING_ANON.

PageAnon tests for page->mapping & PAGE_MAPPING_ANON,
ie. whether page->mapping is already pointing to an
anon_vma.

If it is, __page_set_anon_rmap should leave the page
mapping pointer alone.

-- 
All rights reversed
