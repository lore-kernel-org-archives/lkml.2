Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750851Ab0DNEBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 00:01:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55642 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750704Ab0DNEBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 00:01:15 -0400
Message-ID: <4BC53D6B.6020501@cn.fujitsu.com>
Date: Wed, 14 Apr 2010 11:58:35 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] KVM MMU: optimize/cleanup for marking parent unsync
References: <4BC2D2E2.1030604@cn.fujitsu.com> <4BC2D390.7050708@cn.fujitsu.com> <20100412171211.GC4976@amt.cnet> <4BC3CE83.8020705@cn.fujitsu.com> <20100413150137.GB24128@amt.cnet> <4BC5353A.30509@cn.fujitsu.com>
In-Reply-To: <4BC5353A.30509@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Xiao Guangrong wrote:
> 
> Actually, the origin code has a bug, the code segment in mmu_parent_walk():
> 
> |	if (!sp->multimapped && sp->parent_pte) {
> |		......
> |		return;
> |	}
> |	hlist_for_each_entry(pte_chain, node, &sp->parent_ptes, link)
> |		for (i = 0; i < NR_PTE_CHAIN_ENTRIES; ++i) {
> |			......
> |		}
> 
> So, if sp->parent_pte == NULL, it's unsafe...

Marcelo, please ignore this, it not a bug, just my mistake, sorry...
