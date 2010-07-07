Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab0GGBzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 21:55:36 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:56121 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751835Ab0GGBzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 21:55:35 -0400
Date: Wed, 7 Jul 2010 11:55:30 +1000
From: Dave Chinner <david@fromorbit.com>
To: David Howells <dhowells@redhat.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] Rearrange i_flags to be consistent with FS_IOC_GETFLAGS
Message-ID: <20100707015530.GE25018@dastard>
References: <20100706230312.GB25018@dastard>
 <20100706001032.GA25018@dastard>
 <20100705154319.31193.56706.stgit@warthog.procyon.org.uk>
 <29431.1278423623@redhat.com>
 <5045.1278459925@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5045.1278459925@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 12:45:25AM +0100, David Howells wrote:
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > I'd prefer generic flags are not dependent on fixed values from a
> > specific filesystem several layers down the storage stack.
> 
> They're not so dependent.

History says otherwise. :)

> They're based on the FS_IOC_[GS]ETFLAGS ioctl which
> even XFS translates its flags for.

Sure, because the ioctl flags values are derived
from the ext2 on-disk format flags and hence don't match anything
XFS related at all.

> These ioctl flags must now remain
> invariant.  Whilst they might have originated as Ext2/3/4 flags, they're now
> independent of that.

Yes, the ioctl flags must remain invariant. OTOH, the generic inode
flags (S_*) have no such invariant requirement and have a history of
frequent change. IMO, that means some flags should not be tied to
the value of a specific subsystem just so a subsystem specific
optimisation can be made. It just seems like a dangerous layering
violation to be making...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
