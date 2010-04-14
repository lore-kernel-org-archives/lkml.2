Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab0DNQz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 12:55:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020Ab0DNQzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 12:55:55 -0400
Date: Wed, 14 Apr 2010 13:35:44 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] KVM MMU: optimize/cleanup for marking parent unsync
Message-ID: <20100414163544.GB5489@amt.cnet>
References: <4BC2D2E2.1030604@cn.fujitsu.com>
 <4BC2D390.7050708@cn.fujitsu.com>
 <20100412171211.GC4976@amt.cnet>
 <4BC3CE83.8020705@cn.fujitsu.com>
 <20100413150137.GB24128@amt.cnet>
 <4BC5353A.30509@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC5353A.30509@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 11:23:38AM +0800, Xiao Guangrong wrote:
> 
> 
> Marcelo Tosatti wrote:
> 
> >>> I'd prefer to not touch it.
> >> This patch avoids walk all parents and i think this overload is really unnecessary.
> >> It has other tricks in this codepath but i not noticed? :-)
> > 
> > My point is that there is no point in optimizing something unless its
> > performance sensitive.
> 
> Hi Marcelo,
> 
> I think optimizing not only means 'performance' but also means 'smaller code'(maybe 'cleanup'
> is more suitable) and 'logic optimize'(do little things), i'm not sure this patch whether can
> improve system performance obviously but it optimize the code logic and reduce code size, and
> it not harm other code and system performance, right? :-)

Right, but this walking code already is compact and stable. Removing the
unused code variables/definitions is fine, but i'd prefer to not change
the logic just for the sake of code reduction.

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
> 
> > And as i recall, mmu_unsync_walk was much more
> > sensitive performance wise than parent walking. Actually, gfn_to_memslot 
> > seems more important since its also noticeable on EPT/NPT hosts.
> 
> Yeah, i also noticed these and i'm looking into these code.

Great.

