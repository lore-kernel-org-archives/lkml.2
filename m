Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab0G3PoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 11:44:01 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59265 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab0G3PoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 11:44:00 -0400
Subject: Re: [PATCH] Tight check of pfn_valid on sparsemem - v4
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Milton Miller <miltonm@bga.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>,
        Kukjin Kim <kgene.kim@samsung.com>
In-Reply-To: <alpine.DEB.2.00.1007300745180.9007@router.home>
References: <20100728155617.GA5401@barrios-desktop>
	 <alpine.DEB.2.00.1007281158150.21717@router.home>
	 <20100728225756.GA6108@barrios-desktop>
	 <alpine.DEB.2.00.1007291038100.16510@router.home>
	 <20100729161856.GA16420@barrios-desktop>
	 <alpine.DEB.2.00.1007291132210.17734@router.home>
	 <20100729170313.GB16420@barrios-desktop>
	 <alpine.DEB.2.00.1007291222410.17734@router.home>
	 <20100729183320.GH18923@n2100.arm.linux.org.uk>
	 <1280436919.16922.11246.camel@nimitz>
	 <20100729221426.GA28699@n2100.arm.linux.org.uk>
	 <1280450338.16922.11735.camel@nimitz>
	 <alpine.DEB.2.00.1007300745180.9007@router.home>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Fri, 30 Jul 2010 08:43:54 -0700
Message-ID: <1280504634.16922.14449.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-30 at 07:48 -0500, Christoph Lameter wrote:
> On Thu, 29 Jul 2010, Dave Hansen wrote:
> 
> > SPARSEMEM_EXTREME would be a bit different.  It's a 2-level lookup.
> > You'd have 16 "section roots", each representing 256MB of address space.
> > Each time we put memory under one of those roots, we'd fill in a
> > 512-section second-level table, which is designed to always fit into one
> > page.  If you start at 256MB, you won't waste all those entries.
> 
> That is certain a solution to the !MMU case and it would work very much
> like a page table. If you have an MMU then the vmemmap sparsemem
> configuration can take advantage of of that to avoid the 2 level lookup.

Yup, couldn't agree more, Christoph.

It wouldn't hurt to have several them available on ARM since the
architecture is so diverse.

-- Dave

