Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab1LNCbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 21:31:17 -0500
Received: from mga03.intel.com ([143.182.124.21]:59835 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731Ab1LNCbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 21:31:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="85448616"
Subject: Re: [PATCH 1/3] slub: set a criteria for slub node partial adding
From: Shaohua Li <shaohua.li@intel.com>
To: David Rientjes <rientjes@google.com>
Cc: "Shi, Alex" <alex.shi@intel.com>, Christoph Lameter <cl@linux.com>,
        "penberg@kernel.org" <penberg@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andi Kleen <ak@linux.intel.com>
In-Reply-To: <alpine.DEB.2.00.1112131726140.8593@chino.kir.corp.google.com>
References: <1322814189-17318-1-git-send-email-alex.shi@intel.com>
	 <alpine.DEB.2.00.1112020842280.10975@router.home>
	 <1323076965.16790.670.camel@debian>
	 <alpine.DEB.2.00.1112061259210.28251@chino.kir.corp.google.com>
	 <1323234673.22361.372.camel@sli10-conroe>
	 <alpine.DEB.2.00.1112062319010.21785@chino.kir.corp.google.com>
	 <1323657793.22361.383.camel@sli10-conroe>
	 <alpine.DEB.2.00.1112131726140.8593@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Dec 2011 10:43:42 +0800
Message-ID: <1323830622.22361.407.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-14 at 09:29 +0800, David Rientjes wrote:
> On Mon, 12 Dec 2011, Shaohua Li wrote:
> 
> > With the per-cpu partial list, I didn't see any workload which is still
> > suffering from the list lock, so I suppose both the trashing approach
> > and pick 25% used slab approach don't help.
> 
> This doesn't necessarily have anything to do with contention on list_lock, 
> it has to do with the fact that ~99% of allocations come from the slowpath 
> since the cpu slab only has one free object when it is activated, that's 
> what the statistics indicated for kmalloc-256 and kmalloc-2k.  That's what 
> I called "slab thrashing": the continual deactivation of the cpu slab and 
> picking from the partial list that would only have one or two free objects 
> causing the vast majority of allocations to require the slowpath.
if vast majority of allocation needs picking from partial list of node,
the list_lock will have contention too. But I'd say avoiding the slab
thrashing does increase fastpath. How much it can improve performance I
don't know. The slowpath (not involving list_lock case, so picking
per-cpu partial list) is already _very_ fast these days.

