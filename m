Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab0FPJlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 05:41:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162Ab0FPJk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 05:40:58 -0400
Message-ID: <4C189C20.2070804@redhat.com>
Date: Wed, 16 Jun 2010 12:40:48 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>,
       Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH 3/6] KVM: MMU: introduce gfn_to_page_atomic() and	gfn_to_pfn_atomic()
References: <4C16E6ED.7020009@cn.fujitsu.com> <4C16E75F.6020003@cn.fujitsu.com> <4C16E7AD.1060101@cn.fujitsu.com> <4C16E999.6050004@cn.fujitsu.com> <4C17625E.3020308@redhat.com> <20100616075918.GA17599@basil.fritz.box> <4C1885DF.80903@redhat.com> <20100616084900.GB17599@basil.fritz.box>
In-Reply-To: <20100616084900.GB17599@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 11:49 AM, Andi Kleen wrote:
>> The page is fine, the page tables are not.  Another task can munmap() the
>> thing while is_hwpoison_address() is running.
>>      
> Ok  that boils down to me not seeing that source.
>
> If it accesses the page tables yes then it's racy. But whoever
> looked up the page tables in the first place should have
> returned an -EFAULT. There's no useful address attached
> to poison.
>    

We need to distinguish between genuine -EFAULT and poisoned address.

That's why I suggested get_user_pages_ptes_fast.  You can return page = 
NULL (-EFAULT) and the pte in the same go.  No race, and useful for 
other cases.

-- 
error compiling committee.c: too many arguments to function

