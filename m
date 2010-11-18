Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab0KRHhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 02:37:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63833 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754850Ab0KRHhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 02:37:43 -0500
Message-ID: <4CE4D8C9.90302@cn.fujitsu.com>
Date: Thu, 18 Nov 2010 15:42:01 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 5/6] KVM: MMU: remove 'clear_unsync' parameter
References: <4CE355A0.6020907@cn.fujitsu.com> <4CE3565D.4080004@cn.fujitsu.com> <20101117164903.GE18959@amt.cnet>
In-Reply-To: <20101117164903.GE18959@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-18 15:38:04,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-18 15:38:04,
	Serialize complete at 2010-11-18 15:38:04
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 12:49 AM, Marcelo Tosatti wrote:
			    bool clear_unsync)
>> +static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>>  {
>>  	int i, offset, nr_present;
>>  	bool host_writable;
>> @@ -781,7 +780,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>>  			u64 nonpresent;
>>  
>>  			if (rsvd_bits_set || is_present_gpte(gpte) ||
>> -			      !clear_unsync)
>> +			      sp->unsync)
>>  				nonpresent = shadow_trap_nonpresent_pte;
>>  			else
>>  				nonpresent = shadow_notrap_nonpresent_pte;
> 
> Its better to keep this explicit as a parameter. 
> 

But after patch 6 (KVM: MMU: cleanup update_pte, pte_prefetch and sync_page functions),
this parameter is not used anymore... i don't have strong opinion on it :-)
