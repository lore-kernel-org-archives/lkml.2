Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab2IRIPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 04:15:45 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:33571 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962Ab2IRIPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 04:15:42 -0400
Message-ID: <50582DA4.8060000@linux.vnet.ibm.com>
Date: Tue, 18 Sep 2012 16:15:32 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 4/5] KVM: MMU: introduce page_fault_start and page_fault_end
References: <5052FF61.3070600@linux.vnet.ibm.com> <5052FFEA.1040607@linux.vnet.ibm.com> <20120915152512.GB3037@amt.cnet>
In-Reply-To: <20120915152512.GB3037@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12091808-3568-0000-0000-0000027AE550
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2012 11:25 PM, Marcelo Tosatti wrote:
> On Fri, Sep 14, 2012 at 05:59:06PM +0800, Xiao Guangrong wrote:
>> Wrap the common operations into these two functions
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> 
> Why? I think people are used to 
> 
> spin_lock(lock)
> sequence
> spin_unlock(lock)

Marcelo,

There are many functions use this style that wrap the lock into the
_start and _end functions in kernel (eg.: cgroup_pidlist_start and
cgroup_pidlist_stop in kernel/cgroup.c).

Actually, i just wanted to remove below duplicate ugly code:

	if (!is_error_pfn(pfn))
		kvm_release_pfn_clean(pfn);

> 
> So its easy to verify whether access to data structures are protected.
> 
> Unrelated to this patch, one opportunity i see to simplify this
> code is:
> 
> - error pfn / mmio pfn / invalid pfn relation
> 
> Have the meaning of this bits unified in a single function/helper, see
> comment to patch 1 (perhaps you can further improve).

Sorry, more detail?

