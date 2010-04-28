Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab0D1SF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 14:05:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755014Ab0D1SFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 14:05:23 -0400
Date: Wed, 28 Apr 2010 15:05:03 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org
Subject: Re: [PATCH] kvm mmu: reduce 50% memory usage
Message-ID: <20100428180503.GJ18168@amt.cnet>
References: <4BD8228D.7090708@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD8228D.7090708@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 07:57:01PM +0800, Lai Jiangshan wrote:
> 
> I think users will enable tdp when their hardwares support ept or npt.
> This patch can reduce about 50% kvm mmu memory usage for they.
> 
> This simple patch use the fact that:
> 
> When sp->role.direct is set, sp->gfns does not contain any essential
> information, leaf sptes reachable from this sp are for a continuate
> guest physical memory range(a linear range).
> So sp->gfns[i](if it was set) equals to sp->gfn + i. (PT_PAGE_TABLE_LEVEL)
> Obviously, it is not essential information, we can calculate it when need.
> 
> It means we don't need sp->gfns when sp->role.direct=1,
> Thus we can save one page usage for every kvm_mmu_page.
> 
> Note:
> Access to sp->gfns must be wrapped by kvm_mmu_page_get_gfn()
> or kvm_mmu_page_set_gfn().
> It is only exposed in FNAME(sync_page).
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Applied, thanks.

