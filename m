Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab1C1Pzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 11:55:37 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49104 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab1C1Pzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 11:55:36 -0400
Subject: Re: [PATCH] xen/balloon: Memory hotplug support for Xen balloon
 driver
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, wdauchy@gmail.com,
        rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20110328094757.GJ13826@router-fw-old.local.net-space.pl>
References: <20110328094757.GJ13826@router-fw-old.local.net-space.pl>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 28 Mar 2011 08:55:27 -0700
Message-ID: <1301327727.31700.8354.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-28 at 11:47 +0200, Daniel Kiper wrote:
> 
> +static enum bp_state reserve_additional_memory(long credit)
> +{
> +       int nid, rc;
> +       u64 start;
> +       unsigned long balloon_hotplug = credit;
> +
> +       start = PFN_PHYS(SECTION_ALIGN_UP(max_pfn));
> +       balloon_hotplug = (balloon_hotplug & PAGE_SECTION_MASK) + PAGES_PER_SECTION;
> +       nid = memory_add_physaddr_to_nid(start); 

Is the 'balloon_hotplug' calculation correct?  I _think_ you're trying
to round up to the SECTION_SIZE_PAGES.  But, if 'credit' was already
section-aligned I think you'll unnecessarily round up to the next
SECTION_SIZE_PAGES boundary.  Should it just be:

	balloon_hotplug = ALIGN(balloon_hotplug, PAGES_PER_SECTION);

You might also want to consider some nicer units for those suckers.
'start_paddr' is _much_ easier to grok than 'start', for instance.

-- Dave

