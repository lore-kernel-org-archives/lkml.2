Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab1C2SUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 14:20:17 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:52633 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab1C2SUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 14:20:15 -0400
Date: Tue, 29 Mar 2011 20:18:52 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Daniel Kiper <dkiper@net-space.pl>, ian.campbell@citrix.com,
        akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, wdauchy@gmail.com,
        rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] xen/balloon: Memory hotplug support for Xen balloon driver
Message-ID: <20110329181852.GD30387@router-fw-old.local.net-space.pl>
References: <20110328094757.GJ13826@router-fw-old.local.net-space.pl> <1301327727.31700.8354.camel@nimitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301327727.31700.8354.camel@nimitz>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 08:55:27AM -0700, Dave Hansen wrote:
> On Mon, 2011-03-28 at 11:47 +0200, Daniel Kiper wrote:
> >
> > +static enum bp_state reserve_additional_memory(long credit)
> > +{
> > +       int nid, rc;
> > +       u64 start;
> > +       unsigned long balloon_hotplug = credit;
> > +
> > +       start = PFN_PHYS(SECTION_ALIGN_UP(max_pfn));
> > +       balloon_hotplug = (balloon_hotplug & PAGE_SECTION_MASK) + PAGES_PER_SECTION;
> > +       nid = memory_add_physaddr_to_nid(start);
>
> Is the 'balloon_hotplug' calculation correct?  I _think_ you're trying
> to round up to the SECTION_SIZE_PAGES.  But, if 'credit' was already
> section-aligned I think you'll unnecessarily round up to the next
> SECTION_SIZE_PAGES boundary.  Should it just be:
>
> 	balloon_hotplug = ALIGN(balloon_hotplug, PAGES_PER_SECTION);

Yes, you are right. I am wrong. I will correct that. However, as I said
ealier I do not like ALIGN() in size context. For me ALIGN() is operation
on an address which aligns this address to specified boundary. That is
why I prefer use here open coded version (I agree that it is the same
to ALIGN()). I think that ROUND() macro would be better in size context.
However, I am not native english speaker and if I missed something correct
me, please.

> You might also want to consider some nicer units for those suckers.

What do you mind ??? I think that in that context PAGES_PER_SECTION
is quite good.

> 'start_paddr' is _much_ easier to grok than 'start', for instance.

OK.

Daniel
