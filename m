Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab1LECJb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 21:09:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:54768 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353Ab1LECJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 21:09:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,295,1320652800"; 
   d="scan'208";a="92263983"
Subject: Re: [PATCH 1/3] slub: set a criteria for slub node partial adding
From: Shaohua Li <shaohua.li@intel.com>
To: Christoph Lameter <cl@linux.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, "Shi, Alex" <alex.shi@intel.com>,
        "penberg@kernel.org" <penberg@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.00.1112021401200.13405@router.home>
References: <1322814189-17318-1-git-send-email-alex.shi@intel.com>
	 <1322825802.2607.10.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1112021401200.13405@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Dec 2011 10:21:04 +0800
Message-ID: <1323051664.22361.358.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-12-03 at 04:02 +0800, Christoph Lameter wrote:
> On Fri, 2 Dec 2011, Eric Dumazet wrote:
> 
> > netperf (loopback or ethernet) is a known stress test for slub, and your
> > patch removes code that might hurt netperf, but benefit real workload.
> >
> > Have you tried instead this far less intrusive solution ?
> >
> > if (tail == DEACTIVATE_TO_TAIL ||
> >     page->inuse > page->objects / 4)
> >          list_add_tail(&page->lru, &n->partial);
> > else
> >          list_add(&page->lru, &n->partial);
> 
> One could also move this logic to reside outside of the call to
> add_partial(). This is called mostly from __slab_free() so the logic could
> be put in there.
I'm wondering where the improvement comes from. The new added partial
page almost always has few free objects (the inuse < objects/4 isn't
popular I thought), that's why we add it to list tail.

