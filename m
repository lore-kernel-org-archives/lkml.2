Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab2FMXxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 19:53:00 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:24772 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752316Ab2FMXw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 19:52:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak0JABMn2U95LAcV/2dsb2JhbABFtA4EgTCBCIIYAQEFOhwjEAgDDgouFCUDIROICrpUFIsdSYVIA5UgiSWGWIJy
Date: Thu, 14 Jun 2012 09:52:56 +1000
From: Dave Chinner <david@fromorbit.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com
Subject: Re: [PATCH 2/2] xfs: add FALLOC_FL_ZERO_RANGE to fallocate
Message-ID: <20120613235256.GX22848@dastard>
References: <1339515364-17374-1-git-send-email-pbonzini@redhat.com>
 <1339515364-17374-3-git-send-email-pbonzini@redhat.com>
 <20120613021610.GQ22848@dastard>
 <4FD8320C.1060308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD8320C.1060308@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 08:24:12AM +0200, Paolo Bonzini wrote:
> Il 13/06/2012 04:16, Dave Chinner ha scritto:
> >> > +	BUG_ON((mode & FALLOC_FL_PUNCH_HOLE) && (mode & FALLOC_FL_ZERO_RANGE));
> > Never put BUG_ON() or BUG() in XFS code that can return an error.
> > Return EINVAL if we chose not to support it, and if it's really
> > something we consider bad, emit a warning to syslog (i.e.
> > xfs_warn()) and potentially add a ASSERT() case so that debug
> > kernels will trip over it. Nobody should be panicing a production
> > system just because a user supplied a set of incorrect syscall
> > paramters....
> 
> I know, the BUG_ON() is because it is ruled out in VFS code.  Of course
> if I remove that code, this will not be a BUG_ON() anymore.

If we put a BUG_ON() for every condition the VFS checked in every
filesystem, we'd have so many BUG_ON checks we wouldn't be able to
find the code. If it's banned at the VFS, there's no need to assert
that inthe filesystem code....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
