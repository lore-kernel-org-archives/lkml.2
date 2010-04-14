Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab0DNCRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 22:17:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62708 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754426Ab0DNCRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 22:17:06 -0400
Message-ID: <4BC52505.6000502@cn.fujitsu.com>
Date: Wed, 14 Apr 2010 10:14:29 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] KVM MMU: fix kvm_mmu_zap_page() and its calling path
References: <4BC2D2E2.1030604@cn.fujitsu.com> <4BC2D345.100@cn.fujitsu.com> <20100412171037.GB4976@amt.cnet> <4BC3CA16.6020106@cn.fujitsu.com> <20100413145927.GA24128@amt.cnet>
In-Reply-To: <20100413145927.GA24128@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Marcelo Tosatti wrote:
> On Tue, Apr 13, 2010 at 09:34:14AM +0800, Xiao Guangrong wrote:
>>
>> Marcelo Tosatti wrote:
>>
>>>> @@ -1483,8 +1483,8 @@ static int mmu_zap_unsync_children(struct kvm *kvm,
>>>>  		for_each_sp(pages, sp, parents, i) {
>>>>  			kvm_mmu_zap_page(kvm, sp);
>>>>  			mmu_pages_clear_parents(&parents);
>>>> +			zapped++;
>>>>  		}
>>>> -		zapped += pages.nr;
>>>>  		kvm_mmu_pages_init(parent, &parents, &pages);
>>>>  	}
>>> Don't see why this is needed? The for_each_sp loop uses pvec.nr.
>> I think mmu_zap_unsync_children() should return the number of zapped pages then we
>> can adjust the number of free pages in kvm_mmu_change_mmu_pages(), but pages.nr no
>> only includes the unsync/zapped pages but also includes their parents.
> 
> Oh i see. I think its safer to check for list_empty then to rely on
> proper accounting there, like __kvm_mmu_free_some_pages does.

Do you mean that we'd better add WARN_ON(list_empty()) code in kvm_mmu_zap_page()?

Thanks,
Xiao
