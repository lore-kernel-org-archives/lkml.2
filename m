Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab2GTCep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 22:34:45 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:45628 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab2GTCeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 22:34:37 -0400
Message-ID: <5008C3B4.1070006@linux.vnet.ibm.com>
Date: Fri, 20 Jul 2012 10:34:28 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 5/9] KVM: MMU: fask check write-protect for direct mmu
References: <50056DB8.7080702@linux.vnet.ibm.com> <50056E59.4090003@linux.vnet.ibm.com> <20120720003917.GA8951@amt.cnet>
In-Reply-To: <20120720003917.GA8951@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12071916-7014-0000-0000-000001955C4A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2012 08:39 AM, Marcelo Tosatti wrote:
> On Tue, Jul 17, 2012 at 09:53:29PM +0800, Xiao Guangrong wrote:
>> If it have no indirect shadow pages we need not protect any gfn,
>> this is always true for direct mmu without nested
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> 
> Xiao,
> 
> What is the motivation? Numbers please.
> 

mmu_need_write_protect is the common path for both soft-mmu and
hard-mmu, checking indirect_shadow_pages can skip hash-table walking
for the case which is tdp is enabled without nested guest.

I will post the Number after I do the performance test.

> In fact, what case was the original indirect_shadow_pages conditional in
> kvm_mmu_pte_write optimizing again?
> 

They are the different paths, mmu_need_write_protect is the real
page fault path, and kvm_mmu_pte_write is caused by mmio emulation.

