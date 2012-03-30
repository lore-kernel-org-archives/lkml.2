Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180Ab2C3EN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 00:13:59 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:52345 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750786Ab2C3ENw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 00:13:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAPYxdU95LDmN/2dsb2JhbABEuR2BCIIJAQEFOhwjEAgDFQMuFCUDIROICbsmE5AaYwSVYJAvgns
Date: Fri, 30 Mar 2012 15:13:48 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        xfs-masters@oss.sgi.com
Subject: Re: [PATCH 05/13] XFS: Fix lock ASSERT on UP
Message-ID: <20120330041348.GF18323@dastard>
References: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
 <1332895637-32572-6-git-send-email-andi@firstfloor.org>
 <20120329232114.GA26342@infradead.org>
 <20120329235201.GF17822@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120329235201.GF17822@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 01:52:01AM +0200, Andi Kleen wrote:
> On Thu, Mar 29, 2012 at 07:21:14PM -0400, Christoph Hellwig wrote:
> > On Tue, Mar 27, 2012 at 05:47:09PM -0700, Andi Kleen wrote:
> > > From: Andi Kleen <ak@linux.intel.com>
> > > 
> > > ASSERT(!spin_is_locked()) doesn't work on UP builds. Replace with a standard
> > > lockdep_assert_held()
> > 
> > The "standard" is assert_spin_locked() - which not only is much cheaper
> > but also has the advantage of working in non-lockdep builds.
> 
> But then you have it unconditional, not just on debug builds.

And the problem with that is what? There is so little overhead to the
check it doesn't matter that it is enabled in production kernels...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
