Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab0DMBgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 21:36:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63371 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754471Ab0DMBgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 21:36:51 -0400
Message-ID: <4BC3CA16.6020106@cn.fujitsu.com>
Date: Tue, 13 Apr 2010 09:34:14 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] KVM MMU: fix kvm_mmu_zap_page() and its calling path
References: <4BC2D2E2.1030604@cn.fujitsu.com> <4BC2D345.100@cn.fujitsu.com> <20100412171037.GB4976@amt.cnet>
In-Reply-To: <20100412171037.GB4976@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Marcelo Tosatti wrote:

>> @@ -1483,8 +1483,8 @@ static int mmu_zap_unsync_children(struct kvm *kvm,
>>  		for_each_sp(pages, sp, parents, i) {
>>  			kvm_mmu_zap_page(kvm, sp);
>>  			mmu_pages_clear_parents(&parents);
>> +			zapped++;
>>  		}
>> -		zapped += pages.nr;
>>  		kvm_mmu_pages_init(parent, &parents, &pages);
>>  	}
> 
> Don't see why this is needed? The for_each_sp loop uses pvec.nr.

I think mmu_zap_unsync_children() should return the number of zapped pages then we
can adjust the number of free pages in kvm_mmu_change_mmu_pages(), but pages.nr no
only includes the unsync/zapped pages but also includes their parents.

Thanks,
Xiao
