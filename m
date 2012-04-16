Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab2DPDjx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 23:39:53 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:37329 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab2DPDjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 23:39:52 -0400
Message-ID: <4F8B944B.7070807@linux.vnet.ibm.com>
Date: Mon, 16 Apr 2012 11:38:51 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 10/16] KVM: MMU: fask check whether page is writable
References: <4F87FA69.5060106@linux.vnet.ibm.com> <4F87FC82.2050302@linux.vnet.ibm.com> <20120414120153.76c3afca3726c14d10581a6c@gmail.com>
In-Reply-To: <20120414120153.76c3afca3726c14d10581a6c@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12041517-6102-0000-0000-0000013F8019
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2012 11:01 AM, Takuya Yoshikawa wrote:

> On Fri, 13 Apr 2012 18:14:26 +0800
> Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:
> 
>> Using bit 1 (PTE_LIST_WP_BIT) in rmap store the write-protect status
>> to avoid unnecessary shadow page walking
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/kvm/mmu.c |   40 ++++++++++++++++++++++++++++++++++------
>>  1 files changed, 34 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 0c6e92d..8b71908 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -796,7 +796,9 @@ static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn)
>>  	return level - 1;
>>  }
>>
>> -#define PTE_LIST_DESC		(0x1ull)
>> +#define PTE_LIST_DESC_BIT	0
>> +#define PTE_LIST_WP_BIT	1
> 
> _BIT ?


What is the problem?

> 
>> @@ -2291,9 +2310,15 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
>>  {
>>  	struct kvm_mmu_page *s;
>>  	struct hlist_node *node;
>> +	unsigned long *rmap;
>>  	bool need_unsync = false;
>>
>> +	rmap = gfn_to_rmap(vcpu->kvm, gfn, PT_PAGE_TABLE_LEVEL);
> 
> Please use consistent variable names.
> 
> In other parts of this patch, you are using rmapp for this.


Okay.

