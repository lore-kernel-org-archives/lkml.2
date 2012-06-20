Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab2FTNVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 09:21:18 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:36899 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab2FTNVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 09:21:17 -0400
Message-ID: <4FE1CE43.9080203@linux.vnet.ibm.com>
Date: Wed, 20 Jun 2012 21:21:07 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v7 02/10] KVM: MMU: abstract spte write-protect
References: <4FE1822D.8010002@linux.vnet.ibm.com> <4FE1825B.1030402@linux.vnet.ibm.com> <20120620180254.8b3a42f8.yoshikawa.takuya@oss.ntt.co.jp> <4FE193AA.8010801@linux.vnet.ibm.com> <20120620215653.15930f3467bc13748d548b0d@gmail.com>
In-Reply-To: <20120620215653.15930f3467bc13748d548b0d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12062003-9264-0000-0000-000001BC91A7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 08:56 PM, Takuya Yoshikawa wrote:

> On Wed, 20 Jun 2012 17:11:06 +0800
> Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:
> 
>> Strange! Why do you think it is wrong? It is just debug code.
> 
> kvm_mmu_slot_remove_write_access() does not use rmap but the debug code says:
> 	rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);


It is not a problem since all sptes which are pointing to gfn is existed in rmap.

> 
>>> If you think it is not a problem, please explain why you think so in
>>> the changelog.
>>
>>
>> It is a from the first place and it is used to debug and not compiled at all.
> 
> It was not in kvm_mmu_slot_remove_write_access() before, no?
> 
> This patch says that the write protection code becomes commonly usable
> function, but it still has rmap_write_protect specific debug code in it;
> using it in kvm_mmu_slot_remove_write_access(), which is not at all related
> to rmap_write_protect, is strange.
> 
> As you say, this is just debug code and does not have any practical problem.
> But randomly putting debug code is not a good thing.
> 


Again, "rmap" does not break the logic, the spte we handle in this function must
be in rmap.

