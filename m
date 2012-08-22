Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab2HVFiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 01:38:12 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:52960 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab2HVFiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 01:38:10 -0400
Message-ID: <50347037.3040209@linux.vnet.ibm.com>
Date: Wed, 22 Aug 2012 13:37:59 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: mmu_notifier: fix inconsistent memory between secondary
 MMU and host
References: <503358FF.3030009@linux.vnet.ibm.com> <20120821150618.GJ27696@redhat.com> <50345735.2000807@linux.vnet.ibm.com> <alpine.LSU.2.00.1208212105370.3415@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1208212105370.3415@eggly.anvils>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12082205-9574-0000-0000-00000414B5F1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 12:12 PM, Hugh Dickins wrote:
> On Wed, 22 Aug 2012, Xiao Guangrong wrote:
>> On 08/21/2012 11:06 PM, Andrea Arcangeli wrote:
>>>
>>> The KSM usage of it looks safe because it will only establish readonly
>>> ptes with it.
>>
>> Hmm, in KSM code, i found this code in replace_page:
>>
>> set_pte_at_notify(mm, addr, ptep, mk_pte(kpage, vma->vm_page_prot));
>>
>> It is possible to establish a writable pte, no?
> 
> No: we only do KSM in private vmas (!VM_SHARED), and because of the
> need to CopyOnWrite in those, vm_page_prot excludes write permission:
> write permission has to be added on COW fault.

After read the code carefully, yes, you are right. Thank you very much
for your explanation, Hugh! :)

