Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab1JJXhH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 19:37:07 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:46177 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753264Ab1JJXhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 19:37:05 -0400
X-Sasl-enc: WP0Kohj64L8C5aj4rLHBGQP849+B2o0gzAkAXXct5fbi 1318289824
Date: Mon, 10 Oct 2011 16:35:31 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, nfont@linux.vnet.ibm.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: memory hotplug: Check if pages are correctly
 reserved on a per-section basis
Message-ID: <20111010233531.GA7234@kroah.com>
References: <20111010071119.GE6418@suse.de>
 <20111010150038.ac161977.akpm@linux-foundation.org>
 <20111010232403.GA30513@kroah.com>
 <20111010162813.7a470ae4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111010162813.7a470ae4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 04:28:13PM -0700, Andrew Morton wrote:
> On Mon, 10 Oct 2011 16:24:03 -0700
> Greg KH <greg@kroah.com> wrote:
> 
> > On Mon, Oct 10, 2011 at 03:00:38PM -0700, Andrew Morton wrote:
> > > On Mon, 10 Oct 2011 08:11:19 +0100
> > > Mel Gorman <mgorman@suse.de> wrote:
> > > 
> > > > It is expected that memory being brought online is PageReserved
> > > > similar to what happens when the page allocator is being brought up.
> > > > Memory is onlined in "memory blocks" which consist of one or more
> > > > sections. Unfortunately, the code that verifies PageReserved is
> > > > currently assuming that the memmap backing all these pages is virtually
> > > > contiguous which is only the case when CONFIG_SPARSEMEM_VMEMMAP is set.
> > > > As a result, memory hot-add is failing on !VMEMMAP configurations
> > > > with the message;
> > > > 
> > > > kernel: section number XXX page number 256 not reserved, was it already online?
> > > > 
> > > > This patch updates the PageReserved check to lookup struct page once
> > > > per section to guarantee the correct struct page is being checked.
> > > > 
> > > 
> > > Nathan's earlier version of this patch is already in linux-next, via
> > > Greg.  We should drop the old version and get the new one merged
> > > instead.
> > 
> > Ok, care to send me what exactly needs to be reverted and what needs to
> > be added?
> 
> Drop
> 
> commit 54f23eb7ba7619de85d8edca6e5336bc33072dbd
> Author: Nathan Fontenot <nfont@austin.ibm.com>
> Date:   Mon Sep 26 10:22:33 2011 -0500
> 
>     memory hotplug: Correct page reservation checking
> 
> and replace it with start-of-this-thread.
> 
> That's assuming that Mel's update passes Nathan's review and testing :)

Ok, I'll wait for that review and testing, and then can someone send me
the patch at the start-of-this-thread as I no longer seem to be able to
find it :(

greg k-h
