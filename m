Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230Ab2EOOEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:04:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:4020 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954Ab2EOOEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:04:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100308260"
Message-ID: <4FB26271.3000708@intel.com>
Date: Tue, 15 May 2012 22:04:33 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
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
References: <1337072138-8323-1-git-send-email-alex.shi@intel.com>  <1337072138-8323-7-git-send-email-alex.shi@intel.com>  <CAPa8GCDsSOrzQwX2qRJyocYAZdGbwjD4t4fjxmWXV6=EoXjXZw@mail.gmail.com> <1337073529.27694.8.camel@twins>
In-Reply-To: <1337073529.27694.8.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 05:18 PM, Peter Zijlstra wrote:

> On Tue, 2012-05-15 at 19:15 +1000, Nick Piggin wrote:
>> So this should go to linux-arch...
>>
>> On 15 May 2012 18:55, Alex Shi <alex.shi@intel.com> wrote:
>>> Not every flush_tlb_mm execution moment is really need to evacuate all
>>> TLB entries, like in munmap, just few 'invlpg' is better for whole
>>> process performance, since it leaves most of TLB entries for later
>>> accessing.
>>>
>>> This patch is changing flush_tlb_mm(mm) to flush_tlb_mm(mm, start, end)
>>> in cases.
>>
>> What happened with Peter's comment about using flush_tlb_range for this?
>>
>> flush_tlb_mm() API should just stay unchanged AFAIKS.
>>
>> Then you need to work out the best way to give range info to the tlb/mmu gather
>> API. Possibly passing in the rage for that guy is OK, which x86 can
>> then implement
>> as flush range.
> 
> Right, most archs that have tlb_flush_range() do range tracking in
> mmu_gather. Our TLB ops fully support that, there's absolutely no need
> to go change the interface for thos.



Ok. this should be your wanted, 
-#define tlb_flush(tlb) flush_tlb_mm((tlb)->mm)
+#define tlb_flush(tlb, start, end) __flush_tlb_range((tlb)->mm, start, end)

If no objection, I will modify the patch accordingly. 
