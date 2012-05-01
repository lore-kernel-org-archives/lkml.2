Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767Ab2EAAIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 20:08:24 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:8984 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756967Ab2EAAIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 20:08:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhQFAJQon095LbQl/2dsb2JhbABEr2OCf4EIggkBAQQBOhwjBQsIAxguFCUDIROICAS6PROQfASVfYlbhmiCeoFK
Date: Tue, 1 May 2012 10:08:15 +1000
From: Dave Chinner <david@fromorbit.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] fadvise: Add _VOLATILE,_ISVOLATILE, and _NONVOLATILE
 flags
Message-ID: <20120501000815.GQ7015@dastard>
References: <1335289787-11089-1-git-send-email-john.stultz@linaro.org>
 <1335289787-11089-3-git-send-email-john.stultz@linaro.org>
 <20120427003953.GC9541@dastard>
 <4F9ABA74.8040404@linux.vnet.ibm.com>
 <20120428013628.GJ9541@dastard>
 <4F9EFF04.4040308@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9EFF04.4040308@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 02:07:16PM -0700, John Stultz wrote:
> On 04/27/2012 06:36 PM, Dave Chinner wrote:
> >That's my concern - that persistent filesystems will have different
> >behaviour to in-memory filesystems. They *must* be consistent in
> >behaviour w.r.t. to stale data exposure, otherwise we are in a world
> >of pain when applications start to use this. Quite frankly, I don't
> >care about performance of VOLATILE ranges, but I care greatly
> >about ensuring filesystems don't expose stale data to user
> >applications....
> >
> I think we're in agreement with the rest of this email, but I do
> want to stress that the performance of volatile ranges will become
> more ciritical, as in order for folks to effectively use them, they
> need to be able to mark and unmark ranges any time they're not using
> the data.

Performance is far less important than data security. Make it safe
first, then optimise performance. As it is, the initial target of
tmpfs - by it's very nature of returning zeros for regions not
backed by pages - is safe w.r.t. stale data exposure, so it will not
be slowed down by using an fallocate "best effort" hole-punching
interface.  The performance of other filesystems is something that
the relevant filesystem developers can worry about....

> So if the overhead is too great for marking and unmarking pages,
> applications will be less likely to "help out".  :)

Devil's Advocate: If the benefit of managing caches in such a manner
is this marginal, then why add the complexity to the kernel?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
