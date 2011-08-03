Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab1HCGBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 02:01:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49515 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754808Ab1HCGBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 02:01:17 -0400
Message-ID: <4E38E4A2.4080705@cn.fujitsu.com>
Date: Wed, 03 Aug 2011 14:03:14 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 08/12] KVM: MMU: fast prefetch spte on invlpg path
References: <4E37DA49.1040000@cn.fujitsu.com> <4E37DB3E.2040306@cn.fujitsu.com> <20110802183657.GA6813@amt.cnet>
In-Reply-To: <20110802183657.GA6813@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-03 14:00:14,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-03 14:00:15,
	Serialize complete at 2011-08-03 14:00:15
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2011 02:36 AM, Marcelo Tosatti wrote:

>>  	mask.cr0_wp = mask.cr4_pae = mask.nxe = 1;
>> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
>> index 0f915b5..3466229 100644
>> --- a/arch/x86/kvm/paging_tmpl.h
>> +++ b/arch/x86/kvm/paging_tmpl.h
>> @@ -666,20 +666,22 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
>>  {
>>  	struct kvm_shadow_walk_iterator iterator;
>>  	struct kvm_mmu_page *sp;
>> -	gpa_t pte_gpa = -1;
>>  	int level;
>>  	u64 *sptep;
>>  
>>  	vcpu_clear_mmio_info(vcpu, gva);
>> +	mmu_topup_memory_caches(vcpu);
> 
> Should handle failure.
> 

Yes, thanks Marcelo! I will fix it.

