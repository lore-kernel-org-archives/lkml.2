Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab1LSCiS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 21:38:18 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:53444 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab1LSCiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 21:38:15 -0500
Message-ID: <4EEEA3D0.9070703@oss.ntt.co.jp>
Date: Mon, 19 Dec 2011 11:39:12 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.24) Gecko/20111103 Thunderbird/3.1.16
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/8] KVM: MMU: do not add a nonpresent spte to rmaps of
 its child
References: <4EEB19AF.5070501@linux.vnet.ibm.com> <4EEB1A41.7090902@linux.vnet.ibm.com>
In-Reply-To: <4EEB1A41.7090902@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/12/16 19:15), Xiao Guangrong wrote:

> -static void mmu_page_add_parent_pte(struct kvm_vcpu *vcpu,
> -				    struct kvm_mmu_page *sp, u64 *parent_pte)
> +static void mmu_page_add_set_parent_pte(struct kvm_vcpu *vcpu,
> +					struct kvm_mmu_page *sp,
> +					u64 *parent_pte)
>   {
>   	if (!parent_pte)
>   		return;
>
> +	mmu_spte_set(parent_pte, __pa(sp->spt) | SHADOW_PAGE_TABLE);
>   	pte_list_add(vcpu, parent_pte,&sp->parent_ptes);
>   }

There are a few prefixes in the kvm mmu code.

	e.g. mmu_page_, kvm_mmu_, kvm_mmu_page_, ...

Sometimes we also use "sp".

How about deciding a consistent way from now on?

E.g.
	if the function is static and for local use only, such a prefix
	can be eliminated,

	if it is used outside of mmu.c, kvm_mmu_ is needed,

	we use sp for kvm_mmu_page,
	...

(just an example)

	Takuya
