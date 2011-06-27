Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab1F0GfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 02:35:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57198 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755692Ab1F0Gd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 02:33:29 -0400
Message-ID: <4E0824AD.9020004@cn.fujitsu.com>
Date: Mon, 27 Jun 2011 14:35:25 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 01/22] KVM: MMU: fix walking shadow page table
References: <4E01FBC9.3020009@cn.fujitsu.com> <4E01FBF4.9070004@cn.fujitsu.com> <20110622171336.GA24700@amt.cnet>
In-Reply-To: <20110622171336.GA24700@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-27 14:32:54,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-27 14:32:54,
	Serialize complete at 2011-06-27 14:32:54
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2011 01:13 AM, Marcelo Tosatti wrote:
> On Wed, Jun 22, 2011 at 10:28:04PM +0800, Xiao Guangrong wrote:
>> Properly check the last mapping, and do not walk to the next level if last spte
>> is met
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>> ---
>>  arch/x86/kvm/mmu.c |    9 +++++----
>>  1 files changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 9c629b5..f474e93 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -1517,10 +1517,6 @@ static bool shadow_walk_okay(struct kvm_shadow_walk_iterator *iterator)
>>  	if (iterator->level < PT_PAGE_TABLE_LEVEL)
>>  		return false;
>>  
>> -	if (iterator->level == PT_PAGE_TABLE_LEVEL)
> 
> Change to >= PT_PAGE_TABLE_LEVEL, checks should be in shadow_walk_okay.
> 

Marcelo,

Sorry, i did not remember, we can not check the last spte in shadow_walk_okay,
otherwise the last spte is skipped in the loop. :-)



