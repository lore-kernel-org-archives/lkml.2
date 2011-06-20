Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab1FTSay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 14:30:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56749 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753330Ab1FTSaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 14:30:52 -0400
Message-ID: <4DFF9256.2070805@cn.fujitsu.com>
Date: Tue, 21 Jun 2011 02:32:54 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 02/15] KVM: MMU: do not update slot bitmap if spte is
 nonpresent
References: <4DEE205E.8000601@cn.fujitsu.com> <4DEE20AD.5060109@cn.fujitsu.com> <20110620162806.GC17130@amt.cnet>
In-Reply-To: <20110620162806.GC17130@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-21 02:30:28,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-21 02:30:28,
	Serialize complete at 2011-06-21 02:30:28
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2011 12:28 AM, Marcelo Tosatti wrote:
> On Tue, Jun 07, 2011 at 08:59:25PM +0800, Xiao Guangrong wrote:
>> Set slot bitmap only if the spte is present
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>> ---
>>  arch/x86/kvm/mmu.c |   15 +++++++--------
>>  1 files changed, 7 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index cda666a..125f78d 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -743,9 +743,6 @@ static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
>>  	struct kvm_mmu_page *sp;
>>  	unsigned long *rmapp;
>>  
>> -	if (!is_rmap_spte(*spte))
>> -		return 0;
>> -
> 
> Not sure if this is safe, what if the spte is set as nonpresent but
> rmap not removed?

It can not happen, since when we set the spte as nonpresent, we always use
drop_spte to remove the rmap, we also do it in set_spte()

> 
> BTW i don't see what patch 1 and this have to do with the goal
> of the series.
> 
>

There are the preparing work for mmio page fault:
- Patch 1 fix the bug in walking shadow page, so we can safely use it to
  lockless-ly walk shadow page
- Patch 2 can avoid add rmap for the mmio spte :-)

