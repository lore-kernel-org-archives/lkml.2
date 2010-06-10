Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab0FJArL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 20:47:11 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:37223 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754869Ab0FJArJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 20:47:09 -0400
Date: Thu, 10 Jun 2010 10:47:01 +1000
From: Dave Chinner <david@fromorbit.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs, 2.6.27=>.32 sync write 10 times slowdown [was: xfs,
 aacraid 2.6.27 => 2.6.32 results in 6 times slowdown]
Message-ID: <20100610004701.GN7869@dastard>
References: <4C0E13A7.20402@msgid.tls.msk.ru>
 <20100608122919.GC7869@dastard>
 <4C0EA938.9000104@msgid.tls.msk.ru>
 <20100608231845.GG7869@dastard>
 <4C0F3819.4000409@msgid.tls.msk.ru>
 <20100609074741.GJ7869@dastard>
 <4C0FE779.8010603@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C0FE779.8010603@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 09, 2010 at 11:11:53PM +0400, Michael Tokarev wrote:
> 09.06.2010 11:47, Dave Chinner wrote:
> >On Wed, Jun 09, 2010 at 10:43:37AM +0400, Michael Tokarev wrote:
> >>09.06.2010 03:18, Dave Chinner wrote:
> >>>On Wed, Jun 09, 2010 at 12:34:00AM +0400, Michael Tokarev wrote:
> >>[]
> >>>>Simple test doing random reads or writes of 4k blocks in a 1Gb
> >>>>file located on an xfs filesystem, Mb/sec:
> >>>>
> >>>>                      sync  direct
> >>>>              read   write   write
> >>>>2.6.27 xfs   1.17    3.69    3.80
> >>>>2.6.32 xfs   1.26    0.52    5.10
> >>>>                     ^^^^
> >>>>2.6.32 ext3  1.19    4.91    5.02
> >
> >Out of curiousity, what does 2.6.34 get on this workload?
> 
> 2.6.34 works quite well:
>      2.6.34 xfs    1.14   4.75    5.00

Ok, so we are looking at a fixed regression, then. What stable
version of 2.6.32 are you testing? A large number of XFS fixes went
into 2.6.32.12 (IIRC, it might have been .13), so maybe the problem
is fixed there. Alternatively, can you use 2.6.34 rather than
2.6.32, or bisect the regression down to a specific set of fixes so
we can consider whether a backport is worth the effort?

> The same is with -o osyncisosync (in .34).  Actually,
> osyncis[od]sync mount options does not change anything, not
> in .32 nor in .34.

I think only osyncisosync exists, and it doesn't do anything
anymore.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
