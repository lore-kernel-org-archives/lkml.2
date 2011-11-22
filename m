Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab1KVT44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 14:56:56 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:63212 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752118Ab1KVT4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 14:56:55 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkICAAf9y055LGY5gWdsb2JhbABEDoRzpVsjAQEWJiWBcgEBBSMPASMPFBAIAw4KAgImAgIUJQMhE6sGkW4SgR6CL4VtgRYElEKJBYhNSw
Date: Wed, 23 Nov 2011 06:56:51 +1100
From: Dave Chinner <david@fromorbit.com>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [3.2-rc2] loop device balance_dirty_pages_nr throttling hang
Message-ID: <20111122195651.GN2386@dastard>
References: <20111121142056.GF2386@dastard>
 <20111122035629.GE20982@localhost>
 <20111122102931.GD8098@dastard>
 <20111122104921.GE8098@dastard>
 <ED3D1B07-DEC4-43C8-80A9-739C4973ABF9@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ED3D1B07-DEC4-43C8-80A9-739C4973ABF9@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 08:17:07AM -0500, Theodore Tso wrote:
> 
> On Nov 22, 2011, at 5:49 AM, Dave Chinner wrote:
> 
> > But, I just noticed that the discard that mkfs.ext4 will result
> > in all the extents being discarded in the underlying image file
> > (due to the fact the loopback device now supports hole
> > punching), so the previous state of the image file is getting
> > trashed by the mkfs.ext4 execution, too. I think I already had a
> > ext4 filesystem in some state before I started running this
> > manual prealloc test....
> 
> Which version of mkfs.ext4 are you using?   We've disabled the
> discard by default (unless configured in via a command-line option
> or a /etc/mke2fs.conf setting since no distribution apparently
> wants to be responsible for running supplying a command that
> causes a crap SSD to turning into a brick; personally, I'd blame
> the manufacturer of the crap SSD, but….)

Whatever I've got installed on my test machines. The machien I
reproduced the problem originally on with sparse files is runningi
mke2fs 1.42-WIP (16-Oct-2011) which is the latest in Debian
unstable, the other that is using a real 17TB array is running
mke2fs 1.42-WIP (02-Jul-2011). I saw the discard occurring

BTW, on a 5PB sparse image file I get this error from the latest
mke2fs above:

$ ls -lh /mnt/scratch/scratch.img
-rw------- 1 root root 4.9P Nov 23 06:50 /mnt/scratch/scratch.img
$ sudo mkfs.ext4 /dev/loop0
mke2fs 1.42-WIP (16-Oct-2011)
/dev/loop0: Cannot create filesystem with requested number of inodes while setting up superblock
$

This version does emit that it is discarding blocks:

$ sudo mkfs.ext4 /dev/loop0
mke2fs 1.42-WIP (16-Oct-2011)
Discarding device blocks: done
Filesystem label=
.....


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
