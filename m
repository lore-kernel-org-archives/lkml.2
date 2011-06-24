Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760296Ab1FXCPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 22:15:39 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:36284 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760240Ab1FXCPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 22:15:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqMCAL/vA055LChDgWdsb2JhbABSpy4VAQEWJiWIc8JdDoYfBJshhnU
Date: Fri, 24 Jun 2011 12:15:34 +1000
From: Dave Chinner <david@fromorbit.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Alex Elder <aelder@sgi.com>, xfs-masters@oss.sgi.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Subject: Re: [PATCH v2] xfs: Silence bounds checking compiler warning
Message-ID: <20110624021534.GA32466@dastard>
References: <4E037001.8090306__42924.0493024283$1308849791$gmane$org@gmail.com>
 <m2boxocvb5.fsf@firstfloor.org>
 <20110623175533.GK11521@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110623175533.GK11521@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 06:55:33PM +0100, Al Viro wrote:
> On Thu, Jun 23, 2011 at 10:27:26AM -0700, Andi Kleen wrote:
> > Maarten Lankhorst <m.b.lankhorst@gmail.com> writes:
> > 
> > > gcc with -Warray-bounds generates a false positive on this
> > > since xfs defines the struct with u8 name[1]; to be able to
> > > add a tag at the end.
> > 
> > A better way would be to define it as name[0]. Then the compiler
> > would know it's a VLA. You may need to check noone relies on
> > the one byte though.
> 
> ... and even better is to write in real C and have u8 name[]; in the
> end of your structure.

Hard to do when the structure is effectively the definition of the
on-disk format. Hence it can't just be changed around and the kernel
recompiled to fix the problem.

> That's the standard C99 for this kind of thing
> (see 6.7.2.1p2, p16).  Zero-sized array is a gccism predating standard
> flexible array members and since the standard syntax is accepted by
> any gcc version that might be recent enough to build the kernel...

This code came from Irix, which means it predates both the gccism
and the C99 standard methods of using flexible array sizes. The code
works so it's never been modified because stuffing about with
structures that define disk formats is not done just for the hell of
it... ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
