Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab0G2RDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 13:03:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42800 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab0G2RDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 13:03:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MKCyESGuAkWvyNJnvMWWLuafN/n4YxL+RTEHoUwoJ60INNDnf+BDD615sMQEJA5Dk1
         lS4YiZAQfqDVQLkCGzsm6OIq8SIqbUGvagIxxnK6UMrHBo0m4zPEcCgJsltT3i+xkKyO
         iMhl/QlhkZ7xUMnj/lfjFaHJ5zHKON+dAkyjA=
Date: Fri, 30 Jul 2010 02:03:13 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Milton Miller <miltonm@bga.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH] Tight check of pfn_valid on sparsemem - v4
Message-ID: <20100729170313.GB16420@barrios-desktop>
References: <AANLkTikCsGHshU8v86SQiuO+UZBCbdjOKN=GyJFPb7rY@mail.gmail.com>
 <alpine.DEB.2.00.1007270929290.28648@router.home>
 <AANLkTinXmkaX38pLjSBCRUS-c84GqpUE7xJQFDDHDLCC@mail.gmail.com>
 <alpine.DEB.2.00.1007281005440.21717@router.home>
 <20100728155617.GA5401@barrios-desktop>
 <alpine.DEB.2.00.1007281158150.21717@router.home>
 <20100728225756.GA6108@barrios-desktop>
 <alpine.DEB.2.00.1007291038100.16510@router.home>
 <20100729161856.GA16420@barrios-desktop>
 <alpine.DEB.2.00.1007291132210.17734@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1007291132210.17734@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 11:47:26AM -0500, Christoph Lameter wrote:
> On Fri, 30 Jul 2010, Minchan Kim wrote:
> 
> > The thing is valid section also have a invalid memmap.
> 
> Oww... . A valid section points to a valid memmap memory block (the page
> structs) but the underlying memory pages may not present. So you can check
> the (useless) page structs for the page state of the not present pages in
> the memory map. If the granularity of the sparsemem mapping is not
> sufficient for your purpose then you can change the sparsemem config
> (configuration is in arch/<arch>/include/asm/sparsemem.h but does not
> exist for arm).
> 
> >      It means section 0 is an incompletely filled section.
> >      Nontheless, current pfn_valid of sparsemem checks pfn loosely.
> >      It checks only mem_section's validation but ARM can free mem_map on hole
> >      to save memory space. So in above case, pfn on 0x25000000 can pass pfn_valid's
> >      validation check. It's not what we want.
> 
> IMHO ARM should not poke holes in the memmap sections. The guarantee of
> the full presence of the section is intentional to avoid having to do
> these checks that you are proposing. The page allocator typically expects
> to be able to check all page structs in one basic allocation unit.
> 
> Also pfn_valid then does not have to touch the pag struct to perform its
> function as long as we guarantee the presence of the memmap section.

Absolutely Right. Many mm guys wanted to do it. 
But Russell doesn't want it. 
Please, look at the discussion. 

http://www.spinics.net/lists/arm-kernel/msg93026.html

In fact, we didn't determine the approache at that time.
But I think we can't give up ARM's usecase although sparse model
dosn't be desinged to the such granularity. and I think this approach
can solve ARM's FLATMEM's pfn_valid problem which is doing binar search. 
So I just tried to solve this problem. But Russell still be quiet. 

Okay. I will wait other's opinion. 
First of all, let's fix the approach.
Russell, Could you speak your opinion about this approach or your suggestion?

-- 
Kind regards,
Minchan Kim
