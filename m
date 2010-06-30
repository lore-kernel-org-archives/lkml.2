Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab0F3BCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 21:02:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52911 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752677Ab0F3BCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 21:02:09 -0400
Message-ID: <4C2A96AE.6020103@cn.fujitsu.com>
Date: Wed, 30 Jun 2010 08:58:22 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 8/10] KVM: MMU: prefetch ptes when intercepted guest
 #PF
References: <4C2498EC.2010006@cn.fujitsu.com> <4C249BEA.1030908@cn.fujitsu.com> <20100628130431.GA6209@amt.cnet> <4C29A9CC.2080508@cn.fujitsu.com> <20100629114446.GB26369@amt.cnet>
In-Reply-To: <20100629114446.GB26369@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Marcelo Tosatti wrote:

>>> Also prefetch should be disabled for EPT, due to lack of accessed bit.
>>>
>> But we call mmu_set_spte() with speculative == false, it not touch the accessed bit.
> 
> There is no accessed bit on EPT. So the aging code (kvm_age_rmapp)
> considers any present translation as accessed. There is no way to
> distinguish between actually accessed translations and prefetched (but
> unused) ones.
> 

You are right, i'll disable the prefetch for EPT in the next version, thanks for
you point it out.
