Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab2FNChA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 22:37:00 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:57482 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab2FNCg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 22:36:59 -0400
Message-ID: <4FD94E39.50107@linux.vnet.ibm.com>
Date: Thu, 14 Jun 2012 10:36:41 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 5/9] KVM: MMU: introduce SPTE_MMU_WRITEABLE bit
References: <4FC470C7.5040700@linux.vnet.ibm.com> <4FC4716A.8030304@linux.vnet.ibm.com> <20120613213905.GD19290@amt.cnet>
In-Reply-To: <20120613213905.GD19290@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12061402-3864-0000-0000-000003529BEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2012 05:39 AM, Marcelo Tosatti wrote:


>> +	if (pt_protect)
>> +		spte &= ~SPTE_MMU_WRITEABLE;
>>  	spte = spte & ~PT_WRITABLE_MASK;
>> -	mmu_spte_update(sptep, spte);
>> +
>> +	*flush = mmu_spte_update(sptep, spte);
> 
> This clears previous flush value when looping over multiple sptes in 
> a single rmapp.
> 


In this case, mmu_spte_update alway return "true" since the spte is
always writable or can-be-writable-lockless.

I will cleanup it in the next version. Thank you, Marcelo!

