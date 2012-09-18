Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab2IRGUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 02:20:32 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:46757 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755379Ab2IRGUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 02:20:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag4KACwSWFB5LJUB/2dsb2JhbABFhR62DwOBAIEIgiABAQU6HCMQCAMYLhQNGAMhEx6HUwMLsRUNiVMUiipjHGqFYgOUDYFUixiFCoJ4gUk
Date: Tue, 18 Sep 2012 16:20:20 +1000
From: Dave Chinner <david@fromorbit.com>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk, cmm@us.ibm.com,
        tytso@mit.edu, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: Re: [RFC v1 00/11] vfs: hot data tracking
Message-ID: <20120918062020.GR11511@dastard>
References: <1347866325-25979-1-git-send-email-zwu.kernel@gmail.com>
 <20120917213009.GH13691@dastard>
 <CAEH94LgfxDa2=TubEFcDAyPD=UPfa2yJ-y0Rn7Dto6zs90xScw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEH94LgfxDa2=TubEFcDAyPD=UPfa2yJ-y0Rn7Dto6zs90xScw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 10:24:55AM +0800, Zhi Yong Wu wrote:
> On Tue, Sep 18, 2012 at 5:30 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Mon, Sep 17, 2012 at 03:18:34PM +0800, zwu.kernel@gmail.com wrote:
> >>  20 files changed, 2275 insertions(+), 1 deletions(-)
> >>  create mode 100644 fs/hot_debugfs.c
> >>  create mode 100644 fs/hot_debugfs.h
> >>  create mode 100644 fs/hot_hash.c
> >>  create mode 100644 fs/hot_hash.h
> >>  create mode 100644 fs/hot_rb.c
> >>  create mode 100644 fs/hot_rb.h
> >>  create mode 100644 fs/hot_track.c
> >>  create mode 100644 fs/hot_track.h
> >>  create mode 100644 include/linux/hot_track.h
> >
> > So, 9 new files for tracking all of this? I'm not sure that so
> > many new files are needed - putting it all in fs/hot_tracking.[ch]
> > might make more sense, or if all 8 fs/hot* files remain, putting
> > them in their own subdirectory might be an idea (like quota).
> If all functions are in two files, they will be large and the logic is
> not so clear. so i prefer the latter. thanks.

A single file is much easier to handle when searching and editting,
though. And realistically:

$ wc -l fs/*.c |sort -nr -k 1 |head -10
  62483 total
   4000 fs/namei.c
   3281 fs/buffer.c
   3169 fs/dcache.c
   2677 fs/namespace.c
   2364 fs/locks.c
   2321 fs/exec.c
   2120 fs/binfmt_elf.c
   2053 fs/splice.c
   1934 fs/eventpoll.c
$

There are plenty of files for a single function/subsystem of around
the aggregate size of this code, so everyone is used to dealing with
this amount of logic for a particular feature in a single file.

I much prefer it that way, to tell the truth, because I find it
fairly common to have 5-10 files open at once when tracking
something through, say, the buffered IO path. If I've now got to
have another 5-10 files open just to track that same code path
through this index, then that makes it much more difficult to
manage than if were all in one .c file.

IOWs, splitting code up into multiple files is not a win when the
resultant files are all small and interdependent and you need to
look at multiple files at the same time to understand what the code
does as a whole....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
