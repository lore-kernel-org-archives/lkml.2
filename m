Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab0FAIIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 04:08:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675Ab0FAIIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 04:08:41 -0400
Message-ID: <4C04C004.4060809@redhat.com>
Date: Tue, 01 Jun 2010 11:08:36 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/5] KVM: MMU: split the operations of kvm_mmu_zap_page()
References: <4C025BDC.1020304@cn.fujitsu.com> <4C025C24.9010200@cn.fujitsu.com> <4C026543.20608@redhat.com> <4C031B5D.3000502@cn.fujitsu.com> <4C039816.5090101@redhat.com> <4C04708F.1090405@cn.fujitsu.com>
In-Reply-To: <4C04708F.1090405@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2010 05:29 AM, Xiao Guangrong wrote:
>
>> How about passing the list as a parameter to prepare() and commit()?  If
>> the lifetime of the list is just prepare/commit, it shouldn't be a global.
>>
>>      
> Does below example code show your meaning correctly?
>
> +	struct list_head free_list = LIST_HEAD_INIT(&free_list);
>
> 	hlist_for_each_entry_safe(sp, node, nn, bucket, hash_link) {
> 		if (sp->gfn == gfn&&  !sp->role.direct
> 		&&  !sp->role.invalid) {
> 			pgprintk("%s: zap %lx %x\n",
> 				 __func__, gfn, sp->role.word);
> +			kvm_mmu_prepare_zap_page(kvm, sp,&free_list);
> 		}
> 	}
> +	kvm_mmu_commit_zap_page(kvm,&free_list);
>
>    

Yes.

-- 
error compiling committee.c: too many arguments to function

