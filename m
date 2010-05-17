Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab0EQAZN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 20:25:13 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:43167 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750793Ab0EQAZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 20:25:11 -0400
Date: Mon, 17 May 2010 10:24:44 +1000
From: Dave Chinner <david@fromorbit.com>
To: Ed Tomlinson <edt@aei.ca>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Lameter <cl@linux.com>,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, npiggin@suse.de
Subject: Re: Defrag in shrinkers
Message-ID: <20100517002444.GJ8120@dastard>
References: <1273821863-29524-1-git-send-email-david@fromorbit.com>
 <alpine.DEB.2.00.1005141244380.9466@router.home>
 <87y6fmmdak.fsf@basil.nowhere.org>
 <201005151308.18090.edt@aei.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005151308.18090.edt@aei.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 15, 2010 at 01:08:17PM -0400, Ed Tomlinson wrote:
> On Friday 14 May 2010 16:36:03 Andi Kleen wrote:
> > Christoph Lameter <cl@linux.com> writes:
> > 
> > > Would it also be possible to add some defragmentation logic when you
> > > revise the shrinkers? Here is a prototype patch that would allow you to
> > > determine the other objects sitting in the same page as a given object.
> > >
> > > With that I hope that you have enough information to determine if its
> > > worth to evict the other objects as well to reclaim the slab page.
> > 
> > I like the idea, it would be useful for the hwpoison code too,
> > when it tries to clean a page.
> 
> If this is done generally we probably want to retune the 'pressure' put on the slab.  The
> whole reason for the callbacks was to keep the 'pressure on the slab proportional to the
> memory pressure (scan rate).  

I don't see that defrag based reclaim changes the concept of
pressure at all. As long as reclaim follows the nr_to_scan
guideline, then it doesn't matter if we do reclaim from the LRU or
reclaim from a list provided by the slab cache....

FWIW, one thing that would be necessary, I think, is to avoid defrag
until a certain level of fragmentation has occurred - we should do
LRU-based reclaim as much as possible, and only trigger defrag-style
reclaim once we hit a trigger (e.g. once the slab is 25% partial
pages).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
