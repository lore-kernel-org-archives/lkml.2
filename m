Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab2GERgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 13:36:21 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:42703 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756250Ab2GERgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 13:36:19 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: N7INBGUVM1lIzk4dpvtx0hwa8Syy3M5uB3jhTg7J.ieshYj
 Lsnwb7PadBMYAAZZjCJ8Ub7XFTt7GMnHc1enPBiegYReTDO1VXKc4ZiROOfi
 iOhdNPXIHsaM1LlXaSTfNjkxXSThR.mPTO.y9rTac40PR9z8SV33d82H89GW
 WScS64_hWn9EAJs3SQF04X3RatxW5q1JjZGITxejXN3opCD3HH9HgOFW.CMd
 l6cb64fIBKFfuxCWjy_VK5.DGtntxhv5Xb3slppmsaHQlXDE77hw0DmwlY37
 PY1Me5p7mKFCsvbWwCHmuJAHlRS3M1t4o1AeOOnJmOl3O3LzX8DSVU1YJ7tS
 9T2PNzPXQEeCZ1kOYm3L6oQzFpW5vkSsuYbwAGJuiffXoxNU40zV6.TPeCD3
 3
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 5 Jul 2012 12:36:13 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Jiang Liu <liuj97@gmail.com>
cc: Jiang Liu <jiang.liu@huawei.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, Mel Gorman <mgorman@suse.de>,
        Yinghai Lu <yinghai@kernel.org>, Tony Luck <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Keping Chen <chenkeping@huawei.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] mm: introduce a safer interface to check whether
 a page is managed by SLxB
In-Reply-To: <4FF5B909.30409@gmail.com>
Message-ID: <alpine.DEB.2.00.1207051229490.8670@router.home>
References: <1341287837-7904-1-git-send-email-jiang.liu@huawei.com> <alpine.DEB.2.00.1207050942540.4984@router.home> <4FF5B909.30409@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jul 2012, Jiang Liu wrote:

> 	I think here PageSlab() is used to check whether a page hosting a memory
> object is managed/allocated by the slab allocator. If it's allocated by slab
> allocator, we could use kfree() to free the object.

This is BS (here? what does that refer to). Could you please respond to my
email?

> 	We encountered this issue when trying to implement physical memory hot-removal.
> After removing a memory device, we need to tear down memory management structures
> of the removed memory device. Those memory management structures may be allocated
> by bootmem allocator at boot time, or allocated by slab allocator at runtime when
> hot-adding memory device. So in our case, PageSlab() is used to distinguish between
> bootmem allocator and slab allocator. With SLUB, some pages will never be released
> due to the issue described above.

Trying to be more detailed that in my last email:

These compound pages could also be allocated by any other kernel subsystem
for metadata purposes and they will never be marked as slab pages. These
generic structures generally cannot be removed.

For the slab allocators: Only kmalloc memory uses the unmarked compound
pages and those kmalloc objects are never recoverable. You can only
recover objects that are in slabs marked reclaimable and those are
properly marked as slab pages.

AFAICT the patchset is pointless.
