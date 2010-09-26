Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab0IZNCq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 09:02:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757815Ab0IZNCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 09:02:45 -0400
Message-ID: <4C9F446B.1030902@redhat.com>
Date: Sun, 26 Sep 2010 15:02:35 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/4] KVM: MMU: support unsync sp out of the protection
 of 'mmu_lock'
References: <4C976D48.6020400@cn.fujitsu.com> <4C976D7C.7090707@cn.fujitsu.com> <4C977B9E.6030208@redhat.com> <4C9AC3EB.1080507@cn.fujitsu.com>
In-Reply-To: <4C9AC3EB.1080507@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/23/2010 05:05 AM, Xiao Guangrong wrote:
> >
> >  How can you drop an active unsync page?
> >
> >  I'm missing something here.
> >
>
> Umm, this feature is used like this:
>
> hold mmu_lock
> increase sp->active_count
> release mmu_lock
> ......
> hold mmu_lock
> increase sp->active_count
> if (!sp->active_count&&  sp->invalid)
> 	kvm_mmu_free_page(sp);
> ......
> release mmu_lock
>
>

Well, the implementation is confusing.  Maybe we should have 
mmu_ref_sp() and mmu_drop_sp() wrappers to manage the reference counts 
and call mmu_free_page() automatically.

-- 
error compiling committee.c: too many arguments to function

