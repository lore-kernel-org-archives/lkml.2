Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab1DGV7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 17:59:07 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:38833 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab1DGV7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 17:59:06 -0400
Subject: Re: [PATCH 1/2] rename alloc_pages_exact()
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Timur Tabi <timur@freescale.com>, Andi Kleen <andi@firstfloor.org>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1104071437130.14967@chino.kir.corp.google.com>
References: <20110407172104.1F8B7329@kernel>
	 <alpine.DEB.2.00.1104071437130.14967@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 07 Apr 2011 14:58:57 -0700
Message-ID: <1302213537.8184.4105.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-07 at 14:40 -0700, David Rientjes wrote:
> > alloc_pages_exact() returns a virtual address.  But, alloc_pages() returns
> > a 'struct page *'.  That makes for very confused kernel hackers.
> > 
> > __get_free_pages(), on the other hand, returns virtual addresses.  That
> > makes alloc_pages_exact() a much closer match to __get_free_pages(), so
> > rename it to get_free_pages_exact().
> > 
> 
> The patch also reverses the arguments of the function in 
> include/linux/gfp.h, undoubtedly to resemble the (mask, order) appearance 
> of __get_free_pages():
> 
> 	-void *alloc_pages_exact(size_t size, gfp_t gfp_mask);
> 	+void *get_free_pages_exact(gfp_t gfp_mask, size_t size);

Thanks.  I dumped the fixes for that in the second patch.  Whoops.  Will
repost.

-- Dave

