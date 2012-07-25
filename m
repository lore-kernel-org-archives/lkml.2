Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab2GYH5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 03:57:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57174 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755853Ab2GYH5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 03:57:41 -0400
Date: Wed, 25 Jul 2012 08:57:37 +0100
From: Mel Gorman <mgorman@suse.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Stable <stable@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/34] mm: Reduce the amount of work done when updating
 min_free_kbytes
Message-ID: <20120725075737.GW9222@suse.de>
References: <1343050727-3045-1-git-send-email-mgorman@suse.de>
 <1343050727-3045-4-git-send-email-mgorman@suse.de>
 <20120724224712.GB4245@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120724224712.GB4245@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 03:47:12PM -0700, Greg KH wrote:
> On Mon, Jul 23, 2012 at 02:38:16PM +0100, Mel Gorman wrote:
> > commit 938929f14cb595f43cd1a4e63e22d36cab1e4a1f upstream.
> > 
> > Stable note: Fixes https://bugzilla.novell.com/show_bug.cgi?id=726210 .
> > 	Large machines with 1TB or more of RAM take a long time to boot
> > 	without this patch and may spew out soft lockup warnings.
> 
> In comparing this with the upstream version, you have a few different
> coding style differences, but no real content difference.  Why?
> 

This was a mistake in my workflow that needs a bit of ironing out.

The mistake is that I took the patch from the distribution kernel which was
merged at a time before the coding style fixes were applied. The upstream
commit and signed-off lines were "fixed" but I failed to refresh the
patch and missed that it differed from upstream. Thanks for catching this.
I'll adjust my workflow and assistant scripts to watch for this sort of
problem in the future.

> > 
> > When min_free_kbytes is updated blocks marked MIGRATE_RESERVE are
> > updated. Ordinarily, this work is unnoticable as it happens early
> > in boot. However, on large machines with 1TB of memory, this can take
> > a considerable time when NUMA distances are taken into account. The bulk
> > of the work is done by pageblock_is_reserved() which examines the
> > metadata for almost every page in the system. Currently, we are doing
> > this far more than necessary as it is only required while there are
> > still blocks to be marked MIGRATE_RESERVE. This patch significantly
> > reduces the amount of work done by setup_zone_migrate_reserve()
> > improving boot times on 1TB machines.
> > 
> > [akpm@linux-foundation.org: coding-style fixes]
> 
> I'm guessing you didn't pick these up?
> 

Correct but due to a mistake, not for any good reason.

> Anyway, I've taken it now as the original one from Linus's tree,
> hopefully this doesn't burn me later in the series...
> 

I hope it didn't.

Thanks Greg.

-- 
Mel Gorman
SUSE Labs
