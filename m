Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760799Ab2C3OFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 10:05:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58101 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759966Ab2C3OFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 10:05:01 -0400
Date: Fri, 30 Mar 2012 16:04:57 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, xfs-masters@oss.sgi.com
Subject: Re: [PATCH 05/13] XFS: Fix lock ASSERT on UP
Message-ID: <20120330140457.GH17822@one.firstfloor.org>
References: <1332895637-32572-1-git-send-email-andi@firstfloor.org> <1332895637-32572-6-git-send-email-andi@firstfloor.org> <20120329232114.GA26342@infradead.org> <20120329235201.GF17822@one.firstfloor.org> <20120330041348.GF18323@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120330041348.GF18323@dastard>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 03:13:48PM +1100, Dave Chinner wrote:
> On Fri, Mar 30, 2012 at 01:52:01AM +0200, Andi Kleen wrote:
> > On Thu, Mar 29, 2012 at 07:21:14PM -0400, Christoph Hellwig wrote:
> > > On Tue, Mar 27, 2012 at 05:47:09PM -0700, Andi Kleen wrote:
> > > > From: Andi Kleen <ak@linux.intel.com>
> > > > 
> > > > ASSERT(!spin_is_locked()) doesn't work on UP builds. Replace with a standard
> > > > lockdep_assert_held()
> > > 
> > > The "standard" is assert_spin_locked() - which not only is much cheaper
> > > but also has the advantage of working in non-lockdep builds.
> > 
> > But then you have it unconditional, not just on debug builds.
> 
> And the problem with that is what? There is so little overhead to the
> check it doesn't matter that it is enabled in production kernels...

It's really interesting how much you guys argue for your buggy construct
which you clearly never tested on a UP build...

Not sure if that is a hot path, but on highly contended locks every cache line
fetch is quite expensive on larger systems.

also I doubt the thing really catches bugs, and if it did you would be 
probably better off with a sparse notation or so.

Anyways I will turn it into the normal assert.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
