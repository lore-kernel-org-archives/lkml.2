Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab2EIDI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 23:08:57 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30885 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab2EIDI4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 23:08:56 -0400
MIME-Version: 1.0
Message-ID: <8a42cbff-f7f2-400a-a9c1-c3b3d73ab979@default>
Date: Tue, 8 May 2012 20:08:29 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>, Pekka Enberg <penberg@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cl@linux-foundation.org
Subject: RE: [PATCH 4/4] zsmalloc: zsmalloc: align cache line size
References: <1336027242-372-1-git-send-email-minchan@kernel.org>
 <1336027242-372-4-git-send-email-minchan@kernel.org>
 <4FA28EFD.5070002@vflare.org> <4FA33E89.6080206@kernel.org>
 <alpine.LFD.2.02.1205071038090.2851@tux.localdomain>
 <4FA7C2BC.2090400@vflare.org> <4FA87837.3050208@kernel.org>
 <731b6638-8c8c-4381-a00f-4ecd5a0e91ae@default> <4FA9C127.5020908@kernel.org>
In-Reply-To: <4FA9C127.5020908@kernel.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Minchan Kim [mailto:minchan@kernel.org]
> Subject: Re: [PATCH 4/4] zsmalloc: zsmalloc: align cache line size
> 
> On 05/08/2012 11:00 PM, Dan Magenheimer wrote:
> 
> >> From: Minchan Kim [mailto:minchan@kernel.org]
> >>> zcache can potentially create a lot of pools, so the latter will save
> >>> some memory.
> >>
> >>
> >> Dumb question.
> >> Why should we create pool per user?
> >> What's the problem if there is only one pool in system?
> >
> > zcache doesn't use zsmalloc for cleancache pages today, but
> > that's Seth's plan for the future.  Then if there is a
> > separate pool for each cleancache pool, when a filesystem
> > is umount'ed, it isn't necessary to walk through and delete
> > all pages one-by-one, which could take quite awhile.
> 
> > ramster needs one pool for each client (i.e. machine in the
> > cluster) for frontswap pages for the same reason, and
> > later, for cleancache pages, one per mounted filesystem
> > per client
> 
> Fair enough.
> 
> Then, how about this interfaces like slab?
> 
> 1. zs_handle zs_malloc(size_t size, gfp_t flags) - share a pool by many subsystem(like kmalloc)
> 2. zs_handle zs_malloc_pool(struct zs_pool *pool, size_t size) - use own pool(like kmem_cache_alloc)
> 
> Any thoughts?

Seems fine to me.

> But some subsystems can't want a own pool for not waste unnecessary memory.

Are you using zsmalloc for something else in the kernel?  I'm
wondering what other subsystem would have random size allocations
always less than a page.

Thanks,
Dan
