Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab0G1W6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 18:58:12 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:58888 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab0G1W6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 18:58:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bG1T9TXibqqQTTNIxdz/N+TC513XGvmjdPqjY9PChjlrglYTMqay0PlIs99nFecfSd
         WouDEvNTowKvBh8fdOsam2OivB6zMoGrpdSc0L71xjb/n4ljS7rtAcq79qCoB60QhLuA
         wxqRAydp1CINHu97swoRXSbioX9RBf5W0wCX4=
Date: Thu, 29 Jul 2010 07:57:56 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Milton Miller <miltonm@bga.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH] Tight check of pfn_valid on sparsemem - v4
Message-ID: <20100728225756.GA6108@barrios-desktop>
References: <pfn.valid.v4.reply.1@mdm.bga.com>
 <AANLkTimtTVvorrR9pDVTyPKj0HbYOYY3aR7B-QWGhTei@mail.gmail.com>
 <pfn.valid.v4.reply.2@mdm.bga.com>
 <20100727171351.98d5fb60.kamezawa.hiroyu@jp.fujitsu.com>
 <AANLkTikCsGHshU8v86SQiuO+UZBCbdjOKN=GyJFPb7rY@mail.gmail.com>
 <alpine.DEB.2.00.1007270929290.28648@router.home>
 <AANLkTinXmkaX38pLjSBCRUS-c84GqpUE7xJQFDDHDLCC@mail.gmail.com>
 <alpine.DEB.2.00.1007281005440.21717@router.home>
 <20100728155617.GA5401@barrios-desktop>
 <alpine.DEB.2.00.1007281158150.21717@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1007281158150.21717@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 12:02:16PM -0500, Christoph Lameter wrote:
> On Thu, 29 Jul 2010, Minchan Kim wrote:
> > invalid memmap pages will be freed by free_memmap and will be used
> > on any place. How do we make sure it has PG_reserved?
> 
> Not present memmap pages make pfn_valid fail already since there is no
> entry for the page table (vmemmap) or blocks are missing in the sparsemem
> tables.
> 
> > Maybe I don't understand your point.
> 
> I thought we are worrying about holes in the memmap blocks containing page
> structs. Some page structs point to valid pages and some are not. The
> invalid page structs need to be marked consistently to allow the check.

The thing is that memmap pages which contains struct page array on hole will be 
freed by free_memmap in ARM. Please loot at arch/arm/mm/init.c.
And it will be used by page allocator as free pages.

-- 
Kind regards,
Minchan Kim
