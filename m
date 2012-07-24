Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab2GXWrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 18:47:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45139 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab2GXWrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 18:47:16 -0400
Date: Tue, 24 Jul 2012 15:47:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Stable <stable@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/34] mm: Reduce the amount of work done when updating
 min_free_kbytes
Message-ID: <20120724224712.GB4245@kroah.com>
References: <1343050727-3045-1-git-send-email-mgorman@suse.de>
 <1343050727-3045-4-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343050727-3045-4-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 02:38:16PM +0100, Mel Gorman wrote:
> commit 938929f14cb595f43cd1a4e63e22d36cab1e4a1f upstream.
> 
> Stable note: Fixes https://bugzilla.novell.com/show_bug.cgi?id=726210 .
> 	Large machines with 1TB or more of RAM take a long time to boot
> 	without this patch and may spew out soft lockup warnings.

In comparing this with the upstream version, you have a few different
coding style differences, but no real content difference.  Why?

> 
> When min_free_kbytes is updated blocks marked MIGRATE_RESERVE are
> updated. Ordinarily, this work is unnoticable as it happens early
> in boot. However, on large machines with 1TB of memory, this can take
> a considerable time when NUMA distances are taken into account. The bulk
> of the work is done by pageblock_is_reserved() which examines the
> metadata for almost every page in the system. Currently, we are doing
> this far more than necessary as it is only required while there are
> still blocks to be marked MIGRATE_RESERVE. This patch significantly
> reduces the amount of work done by setup_zone_migrate_reserve()
> improving boot times on 1TB machines.
> 
> [akpm@linux-foundation.org: coding-style fixes]

I'm guessing you didn't pick these up?

Anyway, I've taken it now as the original one from Linus's tree,
hopefully this doesn't burn me later in the series...

thanks,

greg k-h
