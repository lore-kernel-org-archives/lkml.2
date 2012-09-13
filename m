Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab2IMJ0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 05:26:16 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:53262 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab2IMJ0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 05:26:14 -0400
Message-ID: <5051A6AE.4090801@linux.vnet.ibm.com>
Date: Thu, 13 Sep 2012 17:26:06 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 09/12] thp: introduce khugepaged_prealloc_page and khugepaged_alloc_page
References: <5028E12C.70101@linux.vnet.ibm.com> <5028E20C.3080607@linux.vnet.ibm.com> <alpine.LSU.2.00.1209111807030.21798@eggly.anvils> <50500360.5020700@linux.vnet.ibm.com> <alpine.LSU.2.00.1209122316200.7831@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1209122316200.7831@eggly.anvils>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12091309-8878-0000-0000-000003FDDD8E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2012 02:27 PM, Hugh Dickins wrote:
> On Wed, 12 Sep 2012, Xiao Guangrong wrote:
>> On 09/12/2012 10:03 AM, Hugh Dickins wrote:
>>
>>> What brought me to look at it was hitting "BUG at mm/huge_memory.c:1842!"
>>> running tmpfs kbuild swapping load (with memcg's memory.limit_in_bytes
>>> forcing out to swap), while I happened to have CONFIG_NUMA=y.
>>>
>>> That's the VM_BUG_ON(*hpage) on entry to khugepaged_alloc_page().
>>
>>>
>>> So maybe 9/12 is just obscuring what was already a BUG, either earlier
>>> in your series or elsewhere in mmotm (I've never seen it on 3.6-rc or
>>> earlier releases, nor without CONFIG_NUMA).  I've not spent any time
>>> looking for it, maybe it's obvious - can you spot and fix it?
>>
>> Hugh,
>>
>> I think i have already found the reason,
> 
> Great, thank you.
> 
>> if i am correct, the bug was existing before my patch.
> 
> Before your patchset?  Are you sure of that?

No. :)

I have told Andrew that the fix patch need not back port in
0/3. Sorry again for my mistake.

