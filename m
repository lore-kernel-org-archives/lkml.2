Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab1K2Dm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 22:42:27 -0500
Received: from mga03.intel.com ([143.182.124.21]:24845 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455Ab1K2Dm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 22:42:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,589,1315206000"; 
   d="scan'208";a="80056705"
Date: Tue, 29 Nov 2011 11:42:22 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/8] readahead: replace ra->mmap_miss with ra->ra_flags
Message-ID: <20111129034222.GD19506@localhost>
References: <20111121091819.394895091@intel.com>
 <20111121093846.378529145@intel.com>
 <20111121150116.094cf194.akpm@linux-foundation.org>
 <20111123124745.GB7174@localhost>
 <20111123123150.8a1ac462.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111123123150.8a1ac462.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 12:31:50PM -0800, Andrew Morton wrote:
> On Wed, 23 Nov 2011 20:47:45 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > > should be ulong, which is compatible with the bitops.h code.
> > > Or perhaps we should use a bitfield and let the compiler do the work.
> > 
> > What if we do
> > 
> >         u16     mmap_miss;
> >         u16     ra_flags;
> > 
> > That would get rid of this patch. I'd still like to pack the various
> > flags as well as pattern into one single ra_flags, which makes it
> > convenient to pass things around (as one single parameter).
> 
> I'm not sure that this will improve things much...
> 
> Again, how does the code look if you use a bitfield and let the
> compiler do the worK?

It results in much clean code, as you may find in the V2 patches :-)

Thanks,
Fengguang
