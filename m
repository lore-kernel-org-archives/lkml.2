Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab0LAJE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 04:04:56 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41272 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab0LAJEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 04:04:53 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 1 Dec 2010 17:59:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: linux-mm@kvack.org, Christoph Lameter <cl@linux.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] Refactor zone_reclaim
Message-Id: <20101201175911.b761ce81.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101201052218.GK2746@balbir.in.ibm.com>
References: <20101130101126.17475.18729.stgit@localhost6.localdomain6>
	<20101130101520.17475.79978.stgit@localhost6.localdomain6>
	<20101201102329.89b96c54.kamezawa.hiroyu@jp.fujitsu.com>
	<20101201044634.GF2746@balbir.in.ibm.com>
	<20101201052218.GK2746@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Dec 2010 10:52:18 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * Balbir Singh <balbir@linux.vnet.ibm.com> [2010-12-01 10:16:34]:
> 
> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-12-01 10:23:29]:
> > 
> > > On Tue, 30 Nov 2010 15:45:55 +0530
> > > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > 
> > > > Refactor zone_reclaim, move reusable functionality outside
> > > > of zone_reclaim. Make zone_reclaim_unmapped_pages modular
> > > > 
> > > > Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> > > 
> > > Why is this min_mapped_pages based on zone (IOW, per-zone) ?
> > >
> > 
> > Kamezawa-San, this has been the design before the refactoring (it is
> > based on zone_reclaim_mode and reclaim based on top of that).  I am
> > reusing bits of existing technology. The advantage of it being
> > per-zone is that it integrates well with kswapd. 
> >
> 

Sorry, what I wanted to here was:

Why min_mapped_pages per zone ?
Why you don't add "limit_for_unmapped_page_cache_size" for the whole system ?

I guess what you really want is "limit_for_unmapped_page_cache_size".

Then, you have to use this kind of mysterious code.
==
(zone_unmapped_file_pages(zone) >
+			UNMAPPED_PAGE_RATIO * zone->min_unmapped_pages))

Thanks,
-Kame

