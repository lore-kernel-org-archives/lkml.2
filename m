Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926Ab2GEOpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:45:23 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:42387 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932288Ab2GEOpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:45:21 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: O89aaFAVM1nUg.RRlhKi342oX8Oo6t_DSSuQdLDiYY4g_a8
 I1d0zxcGyFx2_3ddOGYQNp4gyetFrX1eFYVkotXzPHD5_slYLIfodT34_JKh
 yyvy3lXNeVXGqP89KBHSTgu2jfoJUTUACEQC_7DwKZ7l.Znf0sVlrsTg5CNC
 l8GdT7lkeNptEpmRHEI3zXggrXNMEo8enXEgNXoBys56kk9nakgqLw_QXeLf
 3smAqs8PKlLw2fP9uPN7HMfRCIiFQ7T6ppyh2BQNVy86w4Y3MYutZHQ.ykvy
 WvrIWYMJJSGqIB0KlVj9GBJYqPIlgEuWHlNEPFAcD2YJkXipDjyyHElbnB1n
 H0OKLl1glNKle1VEy5BIDPO3Th5.uL55.6m281jPEfxBEmEefTXd5Mz86Jak
 w
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 5 Jul 2012 09:45:16 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Jiang Liu <jiang.liu@huawei.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Mel Gorman <mgorman@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Keping Chen <chenkeping@huawei.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: Re: [RFC PATCH 1/4] mm: introduce a safer interface to check whether
 a page is managed by SLxB
In-Reply-To: <1341287837-7904-1-git-send-email-jiang.liu@huawei.com>
Message-ID: <alpine.DEB.2.00.1207050942540.4984@router.home>
References: <1341287837-7904-1-git-send-email-jiang.liu@huawei.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2012, Jiang Liu wrote:

> Several subsystems, including memory-failure, swap, sparse, DRBD etc,
> use PageSlab() to check whether a page is managed by SLAB/SLUB/SLOB.
> And they treat slab pages differently from pagecache/anonymous pages.
>
> But it's unsafe to use PageSlab() to detect whether a page is managed by
> SLUB. SLUB allocates compound pages when page order is bigger than 0 and
> only sets PG_slab on head pages. So if a SLUB object is hosted by a tail
> page, PageSlab() will incorrectly return false for that object.

This is not an issue only with slab allocators. Multiple kernel systems
may do a compound order allocation for some or the other metadata and
will not mark the page in any special way. What makes the slab allocators
so special that you need to do this?

> So introduce a transparent huge page and compound page safe macro as below
> to check whether a page is managed by SLAB/SLUB/SLOB allocator.

Why? Any page is unsafe to touch unless you can account for all references to
the page.

