Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab2GZB1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 21:27:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab2GZB13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 21:27:29 -0400
Date: Wed, 25 Jul 2012 21:27:14 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, law@redhat.com,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] posix_types.h: Cleanup stale __NFDBITS and related
 definitions
Message-ID: <20120726012713.GA2356@zod.bos.redhat.com>
References: <20120725144033.GK10534@zod.bos.redhat.com>
 <1343258796.5132.164.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343258796.5132.164.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 12:26:36AM +0100, Ben Hutchings wrote:
> On Wed, 2012-07-25 at 10:40 -0400, Josh Boyer wrote:
> > Recently, glibc made a change to suppress sign-conversion warnings in FD_SET
> > (glibc commit ceb9e56b3d1).  This uncovered an issue with the kernel's
> > definition of __NFDBITS if applications #include <linux/types.h> after
> > including <sys/select.h>.  A build failure would be seen when passing the
> > -Werror=sign-compare and -D_FORTIFY_SOURCE=2 flags to gcc.
> > 
> > It was suggested that the kernel should either match the glibc definition of
> > __NFDBITS or remove that entirely.  The current in-kernel uses of __NFDBITS
> > can be replaced with BITS_PER_LONG, and there are no uses of the related
> > __FDELT and __FDMASK defines.  Given that, we'll continue the cleanup that
> > was started with commit 8b3d1cda4f5f ("posix_types: Remove fd_set macros")
> > and drop the remaining unused macros.
> > 
> > Additionally, linux/time.h has similar macros defined that expand to nothing
> > so we'll remove those at the same time.
> > 
> > Reported-by: Jeff Law <law@redhat.com>
> > Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> > CC: <stable@vger.kernel.org>
> 
> # v3.4+
> 
> (as 8b3d1cda4f5f went into 3.4)
>

Indeed.  However, I believe Linus pointed out that even before
8b3d1cda4f5f the macros that were removed weren't actually used.
It's likely safe to go back further than just 3.4.

I'll verify again in the morning and include the furthest back we could
remove these.  For now, let's go with what you suggest to be safe.

josh
