Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab0ELGYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 02:24:12 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:33196 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab0ELGYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 02:24:05 -0400
Message-ID: <4BEA4A62.20100@oss.ntt.co.jp>
Date: Wed, 12 May 2010 15:27:46 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>, avi@redhat.com,
       agraf@suse.de, fernando@oss.ntt.co.jp, kvm@vger.kernel.org,
       kvm-ppc@vger.kernel.org, kvm-ia64@vger.kernel.org, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       arnd@arndb.de, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH RFC 10/12] KVM: move dirty bitmaps to user space
References: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com> <20100504220702.f8ba6ccc.takuya.yoshikawa@gmail.com> <20100511032827.GA3458@amt.cnet>
In-Reply-To: <20100511032827.GA3458@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>   	r = 0;
>> @@ -1195,11 +1232,16 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
>>   	gfn = unalias_gfn(kvm, gfn);
>>   	memslot = gfn_to_memslot_unaliased(kvm, gfn);
>>   	if (memslot&&  memslot->dirty_bitmap) {
>> -		unsigned long rel_gfn = gfn - memslot->base_gfn;
>> +		int nr = generic_le_bit_offset(gfn - memslot->base_gfn);
>>
>> -		generic___set_le_bit(rel_gfn, memslot->dirty_bitmap);
>> +		if (kvm_set_bit_user(nr, memslot->dirty_bitmap))
>> +			goto out_fault;
>
> mark_page_dirty is called with the mmu_lock spinlock held in set_spte.
> Must find a way to move it outside of the spinlock section.
>

Oh, it's a serious problem. I have to consider it.


Thanks,
   Takuya
