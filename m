Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568Ab0HOQNR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 12:13:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758501Ab0HOQNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 12:13:16 -0400
Message-ID: <4C67CC06.7070707@redhat.com>
Date: Sun, 15 Aug 2010 14:14:14 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: make mmu_shrink() fit shrinker's requirement
References: <4C591313.50402@cn.fujitsu.com>  <4C5A844C.60105@redhat.com> <1281730204.30865.12.camel@nimitz>
In-Reply-To: <1281730204.30865.12.camel@nimitz>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/13/2010 11:10 PM, Dave Hansen wrote:
> On Thu, 2010-08-05 at 12:28 +0300, Avi Kivity wrote:
>> On 08/04/2010 10:13 AM, Lai Jiangshan wrote:
>>> mmu_shrink() should attempt to free @nr_to_scan entries.
>> This conflicts with Dave's patchset.
>>
>> Dave, what's going on with those patches?  They're starting to smell.
> These seem to fix the original problem reporter's issue.  They were run
> with 64 guests on a 32GB machine.  No stability problems popped up in
> this testing, or since I last sent the patches to you.  The results from
> both the test with only the first four patches and with the entire set
> of nine looked pretty identical.
>
> That tells me that we should only push the first four for now:
>
> 	abstract kvm x86 mmu->n_free_mmu_pages
> 	rename x86 kvm->arch.n_alloc_mmu_pages
> 	replace x86 kvm n_free_mmu_pages with n_used_mmu_pages
> 	create aggregate kvm_total_used_mmu_pages value

Well, patches 3 and 4 have unaddressed review comments. Please fix them 
up. If you don't have the time, let me know and I'll do it instead.

-- 
error compiling committee.c: too many arguments to function

