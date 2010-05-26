Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259Ab0EZLXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 07:23:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759243Ab0EZLXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 07:23:37 -0400
Message-ID: <4BFD04B4.6050409@redhat.com>
Date: Wed, 26 May 2010 14:23:32 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org
Subject: Re: [RESEND PATCH 1/3] kvm: calculate correct gfn for small host
 pages which emulates large guest pages
References: <4BD97AC1.8070704@cn.fujitsu.com> <4BFCE053.6040505@cn.fujitsu.com>
In-Reply-To: <4BFCE053.6040505@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2010 11:48 AM, Lai Jiangshan wrote:
> In Document/kvm/mmu.txt:
>    gfn:
>      Either the guest page table containing the translations shadowed by this
>      page, or the base page frame for linear translations. See role.direct.
>
> But in function FNAME(fetch)(), sp->gfn is incorrect when one of following
> situations occurred:
>   1) guest is 32bit paging and the guest PDE maps a 4-MByte page
>      (backed by 4k host pages), FNAME(fetch)() miss handling the quadrant.
>
>      And if guest use pse-36, "table_gfn = gpte_to_gfn(gw->ptes[level - delta]);"
>      is incorrect.
>   2) guest is long mode paging and the guest PDPTE maps a 1-GByte page
>      (backed by 4k or 2M host pages).
>
> So we fix it to suit to the document and suit to the code which
> requires sp->gfn correct when sp->role.direct=1.
>
> We use the goal mapping gfn(gw->gfn) to calculate the base page frame
> for linear translations, it is simple and easy to be understood.
>    

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

