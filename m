Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732Ab2KZVMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 16:12:06 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:30438 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754031Ab2KZVMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 16:12:05 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsUIALnZs1B5LFFR/2dsb2JhbABEhT+0XoYGF3OCHgEBBTocIxAIAxguFCUDIROIDLA4kDYUjCOEQQOWAJBFgwM
Date: Tue, 27 Nov 2012 08:12:00 +1100
From: Dave Chinner <david@fromorbit.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Theodore Ts'o" <tytso@mit.edu>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Message-ID: <20121126211200.GI6434@dastard>
References: <1353366267-15629-1-git-send-email-david@fromorbit.com>
 <20121126002814.GM32450@dastard>
 <20121126025520.GC22858@thunk.org>
 <20121126115345.19977e46@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121126115345.19977e46@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 11:53:45AM +0000, Alan Cox wrote:
> > It's not like there is any shortage of flag bits, so what's the harm
> > of reserving the bit?
> 
> Why not just reserve a small group of bits for fs private use in that
> case - for any fs.

Flawed - one bit, one function for all filesystems, otherwise the
same binary could behave very differently on different filesystems.

Besides, we already have a mechanism for adding filesystem specific
interfaces. It's called an ioctl.  That's what it's there for - a
free-form extensible interface that can be wholly defined and
contained in the out-of-tree patch.

Most filesystems implement ioctls for their own specific
functionality, including for one-off preallocation semantics (e.g.
XFS_IOC_ZERO_RANGE). There is no reason why ext4 can't do the same
thing and we can drop the whole issue of having to modify a syscall
API with magic, undocumented flag bits with unpredictable
behaviour....

ext4 is not a special snowflake that allows developers to bend rules
whenever they want. If the ext4 developers want to support out of
tree functionality for their filesystem, then they can do it within
their filesystem via ioctls like everyone else does.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
