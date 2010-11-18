Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab0KRJcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 04:32:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769Ab0KRJcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 04:32:08 -0500
Message-ID: <4CE4F292.2060608@redhat.com>
Date: Thu, 18 Nov 2010 11:32:02 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/6] KVM: MMU: fix forgot flush vcpu tlbs
References: <4CE355A0.6020907@cn.fujitsu.com> <20101117152943.GA18959@amt.cnet> <4CE4024B.4090600@redhat.com> <20101117173616.GG18959@amt.cnet> <4CE4D306.6030707@cn.fujitsu.com>
In-Reply-To: <4CE4D306.6030707@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 09:17 AM, Xiao Guangrong wrote:
> On 11/18/2010 01:36 AM, Marcelo Tosatti wrote:
>
> >>  I don't think we need to flush immediately; set a "tlb dirty" bit
> >>  somewhere that is cleareded when we flush the tlb.
> >>  kvm_mmu_notifier_invalidate_page() can consult the bit and force a
> >>  flush if set.
> >
> >  Yep.
> >
>
> Great, i'll do it in the v3.
>
> Do we need a simple bug fix patch(which immediately flush tlbs) for
> backport first?

Oh yes.  Simple fix first, clever ideas later (which will likely need to 
be fixed anyway).


-- 
error compiling committee.c: too many arguments to function

