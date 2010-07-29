Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170Ab0G2Uzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 16:55:35 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:50392 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab0G2Uze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 16:55:34 -0400
Subject: Re: [PATCH] Tight check of pfn_valid on sparsemem - v4
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Milton Miller <miltonm@bga.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>,
        Kukjin Kim <kgene.kim@samsung.com>
In-Reply-To: <20100729183320.GH18923@n2100.arm.linux.org.uk>
References: <AANLkTinXmkaX38pLjSBCRUS-c84GqpUE7xJQFDDHDLCC@mail.gmail.com>
	 <alpine.DEB.2.00.1007281005440.21717@router.home>
	 <20100728155617.GA5401@barrios-desktop>
	 <alpine.DEB.2.00.1007281158150.21717@router.home>
	 <20100728225756.GA6108@barrios-desktop>
	 <alpine.DEB.2.00.1007291038100.16510@router.home>
	 <20100729161856.GA16420@barrios-desktop>
	 <alpine.DEB.2.00.1007291132210.17734@router.home>
	 <20100729170313.GB16420@barrios-desktop>
	 <alpine.DEB.2.00.1007291222410.17734@router.home>
	 <20100729183320.GH18923@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Thu, 29 Jul 2010 13:55:19 -0700
Message-ID: <1280436919.16922.11246.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-29 at 19:33 +0100, Russell King - ARM Linux wrote:
> And no, setting the sparse section size to 512kB doesn't work - memory is
> offset by 256MB already, so you need a sparsemem section array of 1024
> entries just to cover that - with the full 256MB populated, that's 512
> unused entries followed by 512 used entries.  That too is going to waste
> memory like nobodies business.

Sparsemem could use some work in the case where memory doesn't start at
0x0.  But, it doesn't seem like it would be _too_ oppressive to add.
It's literally just adding an offset to all of the places where a
physical address is stuck into the system.  It'll make a few of the
calculations longer, of course, but it should be manageable.

Could you give some full examples of how the memory is laid out on these
systems?  I'm having a bit of a hard time visualizing it.

As Christoph mentioned, SPARSEMEM_EXTREME might be viable here, too.

If you free up parts of the mem_map[] array, how does the buddy
allocator still work?  I thought we required at 'struct page's to be
contiguous and present for at least 2^MAX_ORDER-1 pages in one go.  

-- Dave

