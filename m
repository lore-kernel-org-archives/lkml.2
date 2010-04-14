Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab0DND0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 23:26:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54964 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751330Ab0DND0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 23:26:15 -0400
Message-ID: <4BC5353A.30509@cn.fujitsu.com>
Date: Wed, 14 Apr 2010 11:23:38 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] KVM MMU: optimize/cleanup for marking parent unsync
References: <4BC2D2E2.1030604@cn.fujitsu.com> <4BC2D390.7050708@cn.fujitsu.com> <20100412171211.GC4976@amt.cnet> <4BC3CE83.8020705@cn.fujitsu.com> <20100413150137.GB24128@amt.cnet>
In-Reply-To: <20100413150137.GB24128@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Marcelo Tosatti wrote:

>>> I'd prefer to not touch it.
>> This patch avoids walk all parents and i think this overload is really unnecessary.
>> It has other tricks in this codepath but i not noticed? :-)
> 
> My point is that there is no point in optimizing something unless its
> performance sensitive.

Hi Marcelo,

I think optimizing not only means 'performance' but also means 'smaller code'(maybe 'cleanup'
is more suitable) and 'logic optimize'(do little things), i'm not sure this patch whether can
improve system performance obviously but it optimize the code logic and reduce code size, and
it not harm other code and system performance, right? :-)

Actually, the origin code has a bug, the code segment in mmu_parent_walk():

|	if (!sp->multimapped && sp->parent_pte) {
|		......
|		return;
|	}
|	hlist_for_each_entry(pte_chain, node, &sp->parent_ptes, link)
|		for (i = 0; i < NR_PTE_CHAIN_ENTRIES; ++i) {
|			......
|		}

So, if sp->parent_pte == NULL, it's unsafe...

> And as i recall, mmu_unsync_walk was much more
> sensitive performance wise than parent walking. Actually, gfn_to_memslot 
> seems more important since its also noticeable on EPT/NPT hosts.

Yeah, i also noticed these and i'm looking into these code.

Thanks,
Xiao
