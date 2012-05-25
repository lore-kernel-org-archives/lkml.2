Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564Ab2EYAaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 20:30:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:47819 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939Ab2EYAaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 20:30:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="157010816"
Message-ID: <4FBED22F.1030607@intel.com>
Date: Fri, 25 May 2012 08:28:31 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Peter Zijlstra <peterz@infradead.org>, Andrew Lutomirski <luto@mit.edu>,
        Jan Beulich <JBeulich@suse.com>, borislav.petkov@amd.com,
        arnd@arndb.de, akinobu.mita@gmail.com, eric.dumazet@gmail.com,
        fweisbec@gmail.com, rostedt@goodmis.org, hughd@google.com,
        jeremy@goop.org, len.brown@intel.com, tony.luck@intel.com,
        yongjie.ren@intel.com, kamezawa.hiroyu@jp.fujitsu.com,
        seto.hidetoshi@jp.fujitsu.com, penberg@kernel.org, yinghai@kernel.org,
        tglx@linutronix.de, akpm@linux-foundation.org, ak@linux.intel.com,
        avi@redhat.com, dhowells@redhat.com, mingo@redhat.com, riel@redhat.com,
        cpw@sgi.com, steiner@sgi.com, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, hpa@zytor.com,
        "asit.k.mallick@intel.com" <asit.k.mallick@intel.com>
Subject: Re: [PATCH v7 8/8] x86/tlb: just do tlb flush on one of siblings
 of SMT
References: <1337782555-8088-1-git-send-email-alex.shi@intel.com>  <1337782555-8088-9-git-send-email-alex.shi@intel.com>  <4FBD18D20200007800085951@nat28.tlf.novell.com>  <1337792984.9783.37.camel@laptop> <1337793338.9783.38.camel@laptop>  <CAObL_7GEzHYV9RbinPmK5D3DkZLiV0Wbz6j8x-Agbi21BM_OgA@mail.gmail.com>  <1337845230.9783.51.camel@laptop>  <CAObL_7FK8Pb7Ahmr0SBaPg1BvPTspr=EKG8v_QfcpdmMyuE5dA@mail.gmail.com> <1337865811.9783.152.camel@laptop> <4FBE39FE.4050001@linux.intel.com> <4FBE3D95.8030501@intel.com> <4FBE4335.6020602@linux.intel.com> <4FBE4671.2090408@intel.com> <4FBE5D01.8040809@linux.intel.com>
In-Reply-To: <4FBE5D01.8040809@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2012 12:08 AM, Arjan van de Ven wrote:

> On 5/24/2012 7:32 AM, Alex Shi wrote:
>>>>> we really really shouldn't do flushing of tlb's on only one half of SMT.
>>
>>>>> SMT sibblings have their own TLB pool at least on some of Intels chips.
>>>>
>>>>
>>>> That is also the biggest question I want to know. Actually, some
>>>> documents, wiki said the SMT sibling just has process registers and
>>>> interrupt part, no any tlb/l1 cache etc, (like intel's doc
>>>> vol6iss1_hyper_threading_technology.pdf).  And the patch runs well on
>>>> NHM EP/WSM EP/NHM EX/SNB EP CPUs.
>>>>
>>>> But hard to get such clearly per cpu info of SMT/HT, so, what the
>>>> detailed Intel chips has 'TLB pool' on SMT?
>>>
>>> all of them.
>>>
>>> the TLB pool is shared as physical resource (dynamic or static, that
>>> depends), but each tlb entry will be tagged for which of the two HT
>>> pairs it's for, and on a logical level, they are completely separate as
>>> a result (as they should be)
>>
>>
>> But, why just flush part of SMT doesn't crash kernel on many benchmarks
>> testing? 
> 
> stale tlb's don't crash the kernel
> they do random weird **** to userspace processes.
> 
> you REALLY don't want to be debugging those.
> 
> There is absolutely NO GUARANTEE that a full tlbflush on one thread
> flushes the other one. (in fact I'd be surprised if it actually did).
> 
> Also remember that there are several levels of TLB and tlb caches, and
> you HAVE to flush all.


Thanks for comments!
BTW,
As my limited knowledge, rewrite cr3 or invlpg will flush all levels TLB
entries in CPU. So, what's you mean of 'HAVE to flush all'?
