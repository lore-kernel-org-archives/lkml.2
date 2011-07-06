Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab1GFBPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 21:15:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63670 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752655Ab1GFBPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 21:15:33 -0400
Message-ID: <4E13B7A1.9010504@cn.fujitsu.com>
Date: Wed, 06 Jul 2011 09:17:21 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 04/19] KVM: MMU: cache mmio info on page fault path
References: <4E0C3178.2080603@cn.fujitsu.com> <4E0C31EA.5070403@cn.fujitsu.com> <20110705190457.GA24417@amt.cnet>
In-Reply-To: <20110705190457.GA24417@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-06 09:14:44,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-06 09:14:46,
	Serialize complete at 2011-07-06 09:14:46
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2011 03:04 AM, Marcelo Tosatti wrote:
		return 0;
>>  
>>  	/* mmio */
>> -	if (is_error_pfn(pfn))
>> -		return kvm_handle_bad_page(vcpu->kvm, walker.gfn, pfn);
>> +	if (is_error_pfn(pfn)) {
>> +		unsigned access = walker.pte_access;
>> +		bool dirty = is_dirty_gpte(walker.ptes[walker.level - 1]);
>> +
>> +		if (dirty)
>> +			access &= ~ACC_WRITE_MASK;
>> +
>> +		return kvm_handle_bad_page(vcpu, mmu_is_nested(vcpu) ? 0 :
>> +					   addr, access, walker.gfn, pfn);
>> +	}
> 
> Don't get this... if guest pte is dirty you cache without allowing
> write access? Why?
> 

Ah, sorry, the logic should be: if pte is not diry, clear write access,
will fix it. Thanks, Marcelo!

