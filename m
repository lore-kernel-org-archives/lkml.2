Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab0GFLcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 07:32:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61665 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752313Ab0GFLcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 07:32:45 -0400
Message-ID: <4C331372.30900@cn.fujitsu.com>
Date: Tue, 06 Jul 2010 19:28:50 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 4/9] KVM: MMU: introduce gfn_to_pfn_atomic() function
References: <4C330918.6040709@cn.fujitsu.com> <4C3309D3.6010109@cn.fujitsu.com> <20100706112259.GV4689@redhat.com>
In-Reply-To: <20100706112259.GV4689@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Gleb Natapov wrote:

>> +	}
>>  
>>  	if (unlikely(npages != 1)) {
>>  		struct vm_area_struct *vma;
>>  
>> +		if (atomic)
>> +			goto return_bad_page;
>> +
> You are skipping hwpoison test and sometimes you will return bad_page
> for something that returns good pfn now without caller even know.
> vma->vm_flags & VM_PFNMAP comes to mind. Is this safe?

No matter about it, we not hope the atomic case return good pfn all the time,
if the page is swapped or it's hwpoison just return bad_page, then we can skip
it in the speculative path.
