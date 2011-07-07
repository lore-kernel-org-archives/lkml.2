Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab1GGEyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 00:54:54 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:39721 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab1GGEyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 00:54:51 -0400
Date: Thu, 7 Jul 2011 10:24:20 +0530
From: Ankita Garg <ankita@in.ibm.com>
To: david@lang.hm
Cc: Pekka Enberg <penberg@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, svaidy@linux.vnet.ibm.com,
        thomas.abraham@linaro.org, Dave Hansen <dave@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 00/10] mm: Linux VM Infrastructure to support Memory
 Power Management
Message-ID: <20110707045420.GA23595@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
References: <1306499498-14263-1-git-send-email-ankita@in.ibm.com>
 <20110629130038.GA7909@in.ibm.com>
 <CAOJsxLHQP=-srK_uYYBsPb7+rUBnPZG7bzwtCd-rRaQa4ikUFg@mail.gmail.com>
 <alpine.DEB.2.02.1107061318190.2535@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1107061318190.2535@asgard.lang.hm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 01:20:55PM -0700, david@lang.hm wrote:
> On Wed, 6 Jul 2011, Pekka Enberg wrote:
> 
> >Why does the allocator need to know about address boundaries? Why
> >isn't it enough to make the page allocator and reclaim policies favor using
> >memory from lower addresses as aggressively as possible? That'd mean
> >we'd favor the first memory banks and could keep the remaining ones
> >powered off as much as possible.
> >
> >IOW, why do we need to support scenarios such as this:
> >
> >  bank 0     bank 1   bank 2    bank3
> >| online  | offline | online  | offline |
> 
> I believe that there are memory allocations that cannot be moved
> after they are made (think about regions allocated to DMA from
> hardware where the hardware has already been given the address space
> to DMA into)
>

Thats true. These are kernel allocations which are not movable. However,
the ZONE_MOVABLE would enable us to create complete movable zones and
the ones that have the kernel allocations could be flagged as kernelcore
zone.
 
> As a result, you may not be able to take bank 2 offline, so your
> option is to either leave banks 0-2 all online, or support emptying
> bank 1 and taking it offline.
> 

-- 
Regards,
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs,
Bangalore, India
