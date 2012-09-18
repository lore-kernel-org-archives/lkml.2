Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571Ab2IRHqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 03:46:24 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:57600 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab2IRHqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 03:46:21 -0400
Message-ID: <505826C4.2050704@linux.vnet.ibm.com>
Date: Tue, 18 Sep 2012 15:46:12 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] KVM: MMU: release noslot pfn on the fail path
 properly
References: <5052FF61.3070600@linux.vnet.ibm.com> <5052FF82.1060106@linux.vnet.ibm.com> <20120915151338.GA3037@amt.cnet>
In-Reply-To: <20120915151338.GA3037@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12091807-1618-0000-0000-0000027F880F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2012 11:13 PM, Marcelo Tosatti wrote:
> On Fri, Sep 14, 2012 at 05:57:22PM +0800, Xiao Guangrong wrote:
>> We can not directly call kvm_release_pfn_clean to release the pfn
>> since we can meet noslot pfn which is used to cache mmio info into
>> spte
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/kvm/mmu.c         |    6 ++++--
>>  arch/x86/kvm/paging_tmpl.h |    6 ++++--
>>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> Its clearer to the reader if is_invalid_pfn() is used instead of 
> is_error_pfn.
> 
> BTW how about killing this unused helper
> 
> static bool mmu_invalid_pfn(pfn_t pfn)
> {
>         return unlikely(is_invalid_pfn(pfn));
> }
> 
> This can be done inlined.

Okay, will do. Thanks Marcelo!


