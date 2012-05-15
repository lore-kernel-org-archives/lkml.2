Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378Ab2EOPBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:01:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:13015 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756104Ab2EOPBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:01:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="144258708"
Message-ID: <4FB26FBC.7040209@intel.com>
Date: Tue, 15 May 2012 23:01:16 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Nick Piggin <npiggin@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, riel@redhat.com, luto@mit.edu, avi@redhat.com,
        len.brown@intel.com, dhowells@redhat.com, fenghua.yu@intel.com,
        borislav.petkov@amd.com, yinghai@kernel.org, ak@linux.intel.com,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk, jmorris@namei.org,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, yongjie.ren@intel.com,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH v5 6/7] x86/tlb: optimizing flush_tlb_mm
References: <1337072138-8323-1-git-send-email-alex.shi@intel.com>  <1337072138-8323-7-git-send-email-alex.shi@intel.com>  <CAPa8GCDsSOrzQwX2qRJyocYAZdGbwjD4t4fjxmWXV6=EoXjXZw@mail.gmail.com>  <4FB2590C.1050303@intel.com> <1337092577.27694.45.camel@twins> <1337093840.27694.56.camel@twins>
In-Reply-To: <1337093840.27694.56.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 10:57 PM, Peter Zijlstra wrote:

> On Tue, 2012-05-15 at 16:36 +0200, Peter Zijlstra wrote:
>> On Tue, 2012-05-15 at 21:24 +0800, Alex Shi wrote:
>>
>>> Sorry. I don't understand what's the comments Peter's made days ago. I should ask for more details originally. 
>>>
>>> So, Peter, the correct change should like following, am I right?
>>>
>>> -#define tlb_flush(tlb) flush_tlb_mm((tlb)->mm)
>>> +#define tlb_flush(tlb, start, end) __flush_tlb_range((tlb)->mm, start, end)
>>
>> No.. the correct change is to do range tracking like the other archs
>> that support flush_tlb_range() do.
>>
>> You do not modify the tlb interface.
>>
>> Again, see: http://marc.info/?l=linux-arch&m=129952026504268&w=2


this code is for multiple architecture, but x86 still need implement
'flush tlb range' with 'invlpg'.

> 
> Just to be _very_ clear, you do not modify:
> 
>  mm/memory.c                     |    9 ++--
>  kernel/fork.c                   |    2 +-   
>  fs/proc/task_mmu.c              |    2 +-
> 


Thanks a lot. I see.

> As it stands your patch breaks compilation on a whole bunch of
> architectures.
> 
> If you touch the TLB interface, you get to touch _ALL_ architectures.


