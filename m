Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596Ab2JKNNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 09:13:12 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:65272 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804Ab2JKNNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 09:13:09 -0400
Message-ID: <5076C5D3.6020104@gmail.com>
Date: Thu, 11 Oct 2012 21:12:51 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 5/5] KVM: MMU: introduce FNAME(prefetch_gpte)
References: <50716EE0.6010504@linux.vnet.ibm.com> <50716FF7.1060704@linux.vnet.ibm.com> <20121010152144.GA29776@amt.cnet>
In-Reply-To: <20121010152144.GA29776@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2012 11:21 PM, Marcelo Tosatti wrote:

>>  	pgprintk("%s: gpte %llx spte %p\n", __func__, (u64)gpte, spte);
>> +
>> +	gfn = gpte_to_gfn(gpte);
>>  	pte_access = sp->role.access & gpte_access(vcpu, gpte);
>>  	protect_clean_gpte(&pte_access, gpte);
>> -	pfn = gfn_to_pfn_atomic(vcpu->kvm, gpte_to_gfn(gpte));
>> +	pfn = pte_prefetch_gfn_to_pfn(vcpu, gfn,
>> +			no_dirty_log && (pte_access & ACC_WRITE_MASK));
> 
> Is this a bugfix?

No. It is a cleanup.

Actually, pte_prefetch_gfn_to_pfn(vcpu, gfn, false) is the same as
gfn_to_pfn_atomic

