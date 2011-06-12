Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab1FLIdT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 04:33:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055Ab1FLIdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 04:33:16 -0400
Message-ID: <4DF479C5.3010002@redhat.com>
Date: Sun, 12 Jun 2011 11:33:09 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 09/15] KVM: MMU: split kvm_mmu_free_page
References: <4DEE205E.8000601@cn.fujitsu.com> <4DEE21AE.9050703@cn.fujitsu.com> <4DF0712B.5050400@redhat.com> <4DF19484.8000707@cn.fujitsu.com>
In-Reply-To: <4DF19484.8000707@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 06:50 AM, Xiao Guangrong wrote:
> >>  +static void kvm_mmu_free_unlock_parts(struct kvm_mmu_page *sp)
> >>  +{
> >>  +    list_del(&sp->link);
> >>  +    free_page((unsigned long)sp->spt);
> >>        kmem_cache_free(mmu_page_header_cache, sp);
> >>    }
> >
> >  The list_del() must be run under a lock, no? it can access kvm->arch.active_mmu_pages.
> >
>
> In prepare path, we have moved the sp from active_mmu_pages to invlaid_list.

It still needs to be accessed under a lock, no matter which list is used.

-- 
error compiling committee.c: too many arguments to function

