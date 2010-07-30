Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab0G3JcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 05:32:10 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36608 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab0G3JcH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 05:32:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HxgmveC3Pi6XUwGxLJNHCOmfZkB7LLDkKTXDjbqB/Sjv0alvpX7/TByqR++cuuwJ+k
         RuVwSaLdJNhwlgDRHloMsu6ythTgB2Qn+BMX2V5WGlZgyJI6nUQGynWZNzxxpgSMs638
         v9LhDWlGnnjj0XXOArXMkqkaIOQEDTEYRcqF8=
MIME-Version: 1.0
In-Reply-To: <1280436919.16922.11246.camel@nimitz>
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
	<1280436919.16922.11246.camel@nimitz>
Date: Fri, 30 Jul 2010 18:32:04 +0900
Message-ID: <AANLkTi=DpH=vmUK84KhvOMgP=KL+YxXD0UhiJE+VRJyg@mail.gmail.com>
Subject: Re: [PATCH] Tight check of pfn_valid on sparsemem - v4
From: Minchan Kim <minchan.kim@gmail.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Christoph Lameter <cl@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Milton Miller <miltonm@bga.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 5:55 AM, Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> On Thu, 2010-07-29 at 19:33 +0100, Russell King - ARM Linux wrote:
>> And no, setting the sparse section size to 512kB doesn't work - memory is
>> offset by 256MB already, so you need a sparsemem section array of 1024
>> entries just to cover that - with the full 256MB populated, that's 512
>> unused entries followed by 512 used entries.  That too is going to waste
>> memory like nobodies business.
>
> Sparsemem could use some work in the case where memory doesn't start at
> 0x0.  But, it doesn't seem like it would be _too_ oppressive to add.
> It's literally just adding an offset to all of the places where a
> physical address is stuck into the system.  It'll make a few of the
> calculations longer, of course, but it should be manageable.
>
> Could you give some full examples of how the memory is laid out on these
> systems?  I'm having a bit of a hard time visualizing it.
>
> As Christoph mentioned, SPARSEMEM_EXTREME might be viable here, too.
>
> If you free up parts of the mem_map[] array, how does the buddy
> allocator still work?  I thought we required at 'struct page's to be
> contiguous and present for at least 2^MAX_ORDER-1 pages in one go.

I think in that case, arch should define CONFIG_HOLES_IN_ZONE to prevent
crash. But I am not sure hole architectures on ARM have been used it well.
Kujkin's problem happens not buddy but walking whole pfn to echo
min_free_kbytes.

>
> -- Dave
>
>



-- 
Kind regards,
Minchan Kim
