Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab0GMCBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 22:01:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58767 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753301Ab0GMCBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 22:01:08 -0400
Message-ID: <4C3BC7F5.80602@cn.fujitsu.com>
Date: Tue, 13 Jul 2010 09:57:09 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 1/9] KVM: MMU: fix forgot reserved bits check in speculative
 path
References: <4C330918.6040709@cn.fujitsu.com> <4C39B81A.5080000@redhat.com> <4C3A7FEA.6030205@cn.fujitsu.com> <4C3B1554.7000005@redhat.com>
In-Reply-To: <4C3B1554.7000005@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:

>>
>> How about only update the shadow page which has the same pae set with
>> the written
>> vcpu? Just like this:
>>
>> @@ -3000,6 +3000,10 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu,
>> gpa_t gpa,
>>                  while (npte--) {
>>                          entry = *spte;
>>                          mmu_pte_write_zap_pte(vcpu, sp, spte);
>> +
>> +                       if (!!is_pae(vcpu) != sp->role.cr4_pae)
>> +                               continue;
>> +
>>    
> 
> Not enough, one vcpu can have nx set while the other has it reset, etc.
> 

Yeah, so we also need check sp->role.nxe here




