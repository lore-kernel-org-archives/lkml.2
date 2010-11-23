Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab0KWKEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 05:04:20 -0500
Received: from gir.skynet.ie ([193.1.99.77]:50644 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab0KWKET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 05:04:19 -0500
Date: Tue, 23 Nov 2010 10:04:03 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Simon Kirby <sim@hostway.ca>, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: Free memory never fully used, swapping
Message-ID: <20101123100402.GH19571@csn.ul.ie>
References: <20101115195246.GB17387@hostway.ca> <20101122154419.ee0e09d2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20101122154419.ee0e09d2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 03:44:19PM -0800, Andrew Morton wrote:
> On Mon, 15 Nov 2010 11:52:46 -0800
> Simon Kirby <sim@hostway.ca> wrote:
> 
> > I noticed that CONFIG_NUMA seems to enable some more complicated
> > reclaiming bits and figured it might help since most stock kernels seem
> > to ship with it now.  This seems to have helped, but it may just be
> > wishful thinking.  We still see this happening, though maybe to a lesser
> > degree.  (The following observations are with CONFIG_NUMA enabled.)
> > 

Hi,

As this is a NUMA machine, what is the value of
/proc/sys/vm/zone_reclaim_mode ? When enabled, this reclaims memory
local to the node in preference to using remote nodes. For certain
workloads this performs better but for users that expect all of memory
to be used, it has surprising results.

If set to 1, try testing with it set to 0 and see if it makes a
difference. Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
