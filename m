Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab1JJXYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 19:24:22 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:54204 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752757Ab1JJXYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 19:24:21 -0400
X-Sasl-enc: uaWPls1HBzDSdJul/I3wqstuwS+iC3ZXT6idLFT3HjBB 1318289060
Date: Mon, 10 Oct 2011 16:24:03 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, nfont@linux.vnet.ibm.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: memory hotplug: Check if pages are correctly
 reserved on a per-section basis
Message-ID: <20111010232403.GA30513@kroah.com>
References: <20111010071119.GE6418@suse.de>
 <20111010150038.ac161977.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111010150038.ac161977.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 03:00:38PM -0700, Andrew Morton wrote:
> On Mon, 10 Oct 2011 08:11:19 +0100
> Mel Gorman <mgorman@suse.de> wrote:
> 
> > It is expected that memory being brought online is PageReserved
> > similar to what happens when the page allocator is being brought up.
> > Memory is onlined in "memory blocks" which consist of one or more
> > sections. Unfortunately, the code that verifies PageReserved is
> > currently assuming that the memmap backing all these pages is virtually
> > contiguous which is only the case when CONFIG_SPARSEMEM_VMEMMAP is set.
> > As a result, memory hot-add is failing on !VMEMMAP configurations
> > with the message;
> > 
> > kernel: section number XXX page number 256 not reserved, was it already online?
> > 
> > This patch updates the PageReserved check to lookup struct page once
> > per section to guarantee the correct struct page is being checked.
> > 
> 
> Nathan's earlier version of this patch is already in linux-next, via
> Greg.  We should drop the old version and get the new one merged
> instead.

Ok, care to send me what exactly needs to be reverted and what needs to
be added?

thanks,

greg k-h
