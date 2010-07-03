Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab0GCLsq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 07:48:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524Ab0GCLsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 07:48:45 -0400
Message-ID: <4C2F2393.9050301@redhat.com>
Date: Sat, 03 Jul 2010 14:48:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 5/6] KVM: MMU: combine guest pte read between walk
 and pte prefetch
References: <4C2C9DC0.8050607@cn.fujitsu.com> <4C2C9E6C.2040803@cn.fujitsu.com> <20100702170303.GC25969@amt.cnet>
In-Reply-To: <20100702170303.GC25969@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2010 08:03 PM, Marcelo Tosatti wrote:
> On Thu, Jul 01, 2010 at 09:55:56PM +0800, Xiao Guangrong wrote:
>    
>> Combine guest pte read between guest pte walk and pte prefetch
>>
>> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
>> ---
>>   arch/x86/kvm/paging_tmpl.h |   48 ++++++++++++++++++++++++++++++-------------
>>   1 files changed, 33 insertions(+), 15 deletions(-)
>>      
> Can't do this, it can miss invlpg:
>
> vcpu0			vcpu1
> read guest ptes
> 			modify guest pte
> 			invlpg
> instantiate stale
> guest pte
>
> See how the pte is reread inside fetch with mmu_lock held.
>    

Note, this is fine if the pte is unsync, since vcpu0 will soon invlpg 
it.  It's only broken for sync ptes.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

