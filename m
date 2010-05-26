Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab0EZKEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 06:04:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab0EZKEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 06:04:31 -0400
Message-ID: <4BFCF22A.8050804@redhat.com>
Date: Wed, 26 May 2010 13:04:26 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org
Subject: Re: [RESEND PATCH 3/3 V2] kvm mmu: reduce 50% memory usage
References: <4BFCE0B7.1090105@cn.fujitsu.com>
In-Reply-To: <4BFCE0B7.1090105@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2010 11:49 AM, Lai Jiangshan wrote:
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
>    

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

