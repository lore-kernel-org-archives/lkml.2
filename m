Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159Ab1KRRPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 12:15:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757567Ab1KRRPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 12:15:22 -0500
Message-ID: <1321636512.26410.132.camel@bling.home>
Subject: Re: [PATCH] intel-iommu: Manage iommu_coherency globally
From: Alex Williamson <alex.williamson@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: rajesh.sankaran@intel.com, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        chrisw@sous-sol.org, ddutile@redhat.com
Date: Fri, 18 Nov 2011 10:15:12 -0700
In-Reply-To: <1321635658.15493.55.camel@shinybook.infradead.org>
References: <20111116040752.11878.18642.stgit@bling.home>
	 <1321617817.15493.33.camel@shinybook.infradead.org>
	 <1321632197.26410.104.camel@bling.home>
	 <1321635658.15493.55.camel@shinybook.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 17:00 +0000, David Woodhouse wrote:
> On Fri, 2011-11-18 at 09:03 -0700, Alex Williamson wrote:
> > I can't help but thinking we're just taking the easy, lazy path for VM
> > domains when it sounds like we really would prefer to keep the coherency
> > set to the least common denominator of the domain rather than the
> > platform.  Couldn't we instead force a flush of the domain when we
> > transition from coherent to non-coherent?  Not sure I'm qualified to
> > write that, but seems like it would keep the efficiency of VM domains
> > with no effect to native DMA domains since they'd never trigger such a
> > transition.  The below appears as if it would work and probably be OK
> > since the unnecessary cache flushes are rare, but they're still
> > unnecessary... and the comments/commit log are now wrong.  Thanks,
> 
> Yeah, that would make some sense. I was about to knock up some code
> which would walk the page tables and use clflush to flush every one...
> but wouldn't it be saner just to use wbinvd?

A bit heavy handed, but obviously easier.  It feels like we could safely
be more strategic, but maybe we'd end up trashing the cache anyway in a
drawn out attempt to flush the context and all page tables.  However, do
we actually need a wbinvd_on_all_cpus()?  Probably better to trash one
cache than all of them.  Thanks,

Alex

