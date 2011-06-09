Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab1FINt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 09:49:57 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46512 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757584Ab1FINtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:49:55 -0400
Date: Thu, 9 Jun 2011 14:49:47 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, Miklos Szeredi <miklos@szeredi.hu>,
        viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        nbd@openwrt.org, hramrach@centrum.cz, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, mszeredi@suse.cz
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
Message-ID: <20110609134947.GD13242@shadowen.org>
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
 <20110608153208.dc705cda.akpm@linux-foundation.org>
 <20110609115934.3c53f78f@notabene.brown>
 <20110608205233.ebfedc4d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110608205233.ebfedc4d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 08:52:33PM -0700, Andrew Morton wrote:

> > > This sort of thing could be implemented in userspace and wired up via
> > > fuse, I assume.  Has that been attempted and why is it inadequate?
> > 
> > I think that would be a valid question if the proposal was large and
> > complex.  But overlayfs is really quite small and self-contained.
> 
> Not merging it would be even smaller and simpler.  If there is a
> userspace alternative then that option should be evaluated and compared
> in a rational manner.

For the Ubuntu liveCD we have tried to use unions via fuse with a view
to dropping aufs2 as an external module.  The performance was atrocious
(IIRC of the order of 10x slower), to the point that most people assumed
it was broken and reset the machine.

The other use case I have seen here have been for package builders on which
a virgin chroot has a writable layer dropped on top, allowing simple undo
at the end of the build.  I have heard of people wanting to use this for
root filesystems for virtual machines as well.

We have done quite a bit of testing with liveCDs built to use overlayfs
with a view to switching over, and have been very impressed with its
stability.  It is also pleasing to see an implementation which is small
enough to actually understand.

-apw
