Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964814Ab1DMXXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 19:23:37 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:43638 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964777Ab1DMXXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 19:23:36 -0400
Subject: Re: [PATCH 2/3] make new alloc_pages_exact()
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        David Rientjes <rientjes@google.com>
In-Reply-To: <op.vtt1clbd3l0zgt@mnazarewicz-glaptop>
References: <20110411220345.9B95067C@kernel>
	 <20110411220346.2FED5787@kernel>
	 <20110411152223.3fb91a62.akpm@linux-foundation.org>
	 <op.vttl1ho83l0zgt@mnazarewicz-glaptop> <1302620653.8321.1725.camel@nimitz>
	 <op.vtt1clbd3l0zgt@mnazarewicz-glaptop>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 13 Apr 2011 16:23:29 -0700
Message-ID: <1302737009.14658.3848.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-12 at 17:58 +0200, Michal Nazarewicz wrote:
> > Actually, the various mem_map[]s _are_ arrays, at least up to
> > MAX_ORDER_NR_PAGES at a time.  We can use that property here.
> 
> In that case, waiting eagerly for the new patch. :) 

I misunderstood earlier.  release_pages() takes an array of 'struct page
*', not an array of 'struct page'.  To use it here, we'd need to
construct temporary arrays.  If we're going to do that, we should
probably just use pagevecs, and if we're going to do _that_, we don't
need release_pages().

Nobody calls free_pages_exact() in any kind of hot path these days.
Most of the users are like kernel profiling where they *never* free the
memory.  I'm not sure it's worth the complexity to optimize this.

-- Dave

