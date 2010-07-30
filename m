Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab0G3MsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 08:48:10 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:41824 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758548Ab0G3MsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 08:48:06 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: ywuPkEcVM1laTJfgBxOeMihDpPjj0gn1U7pHLqQVCuZFTgi
 8jvzQrPssrN1hdG6PiwwFQlxG6gSz.dxWfv2QLADbcDISksCerlG37pOkJBC
 XmnkEt6YS39KLdyx37dWM7Xs9OYkqV17Aw6NrJG.9zHgOdTreLc64NbPhMD.
 1PAh6PO9DMjEUZhYcfPRItAw3_4rvMAMzXLhy9cWeSLxBO_vj5kudDDgwE29
 tFwBwS2ij5IIzP9hlN5DKPcBM_d0Uf0OmcnRLHWYlO456hO0P
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 30 Jul 2010 07:48:00 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Milton Miller <miltonm@bga.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH] Tight check of pfn_valid on sparsemem - v4
In-Reply-To: <1280450338.16922.11735.camel@nimitz>
Message-ID: <alpine.DEB.2.00.1007300745180.9007@router.home>
References: <20100728155617.GA5401@barrios-desktop>  <alpine.DEB.2.00.1007281158150.21717@router.home>  <20100728225756.GA6108@barrios-desktop>  <alpine.DEB.2.00.1007291038100.16510@router.home>  <20100729161856.GA16420@barrios-desktop> 
 <alpine.DEB.2.00.1007291132210.17734@router.home>  <20100729170313.GB16420@barrios-desktop>  <alpine.DEB.2.00.1007291222410.17734@router.home>  <20100729183320.GH18923@n2100.arm.linux.org.uk>  <1280436919.16922.11246.camel@nimitz> 
 <20100729221426.GA28699@n2100.arm.linux.org.uk> <1280450338.16922.11735.camel@nimitz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jul 2010, Dave Hansen wrote:

> SPARSEMEM_EXTREME would be a bit different.  It's a 2-level lookup.
> You'd have 16 "section roots", each representing 256MB of address space.
> Each time we put memory under one of those roots, we'd fill in a
> 512-section second-level table, which is designed to always fit into one
> page.  If you start at 256MB, you won't waste all those entries.

That is certain a solution to the !MMU case and it would work very much
like a page table. If you have an MMU then the vmemmap sparsemem
configuration can take advantage of of that to avoid the 2 level lookup.
