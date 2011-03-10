Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab1CJIw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 03:52:59 -0500
Received: from router-fw.net-space.pl ([89.174.63.77]:42394 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab1CJIw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 03:52:58 -0500
Date: Thu, 10 Mar 2011 09:51:36 +0100
From: Daniel Kiper <dkiper@net-space.pl>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Daniel Kiper <dkiper@net-space.pl>, ian.campbell@citrix.com,
        akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, wdauchy@gmail.com,
        rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH R4 6/7] mm: Extend memory hotplug API to allow memory hotplug in virtual guests
Message-ID: <20110310085136.GA13978@router-fw-old.local.net-space.pl>
References: <20110308215003.GG27331@router-fw-old.local.net-space.pl> <1299628272.9014.3465.camel@nimitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299628272.9014.3465.camel@nimitz>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 03:51:12PM -0800, Dave Hansen wrote:
> On Tue, 2011-03-08 at 22:50 +0100, Daniel Kiper wrote:
> > +int add_virtual_memory(u64 *size)
> > +{
> > +	int nid;
> > +	u64 start;
> > +
> > +	start = PFN_PHYS(SECTION_ALIGN(max_pfn));
> > +	*size = (((*size >> PAGE_SHIFT) & PAGE_SECTION_MASK) + PAGES_PER_SECTION) << PAGE_SHIFT;
>
> Why use PFN_PHYS() in one case but not the other?

I know that this is the same, however, I think PFN_PHYS() usage suggest
that I do a PFN/address manipulation. It is not true in that case (I do
an operation on region size) and I would like to avoid that ambiguity.

> I'd also highly suggest using the ALIGN() macro in cases like this.  It
> makes it much more readable:

OK.

> 	*size = PFN_PHYS(ALIGN(*size, SECTION_SIZE)));
>
> > +	nid = memory_add_physaddr_to_nid(start);
> > +
> > +	return add_memory(nid, start, *size);
> > +}
>
> Could you talk a little bit more about how 'size' gets used?  Also, are
> we sure we want an interface where we're so liberal with 'size'?  It
> seems like requiring that it be section-aligned is a fair burden to
> place on the caller.  That way, we're not in a position of _guessing_
> what the caller wants (aligning up or down).

I do not have like this function since I created it. However,
I decided to sent it for review. It does not simplify anything
(add_memory() as a generic function is sufficient) and it is
too inflexible. Now, I am sure that everything in its body
should be moved to platform specific module (in that case Xen).
I am going to that on next patch release.

Daniel
