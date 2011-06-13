Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab1FMBxL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 21:53:11 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62239 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656Ab1FMBxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 21:53:07 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs updates
In-reply-to: <m262oar1a9.fsf@firstfloor.org>
References: <1307879298-sup-3080@shiny> <m262oar1a9.fsf@firstfloor.org>
Date: Sun, 12 Jun 2011 21:52:21 -0400
Message-Id: <1307929838-sup-4118@shiny>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090205.4DF56D60.0043:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Andi Kleen's message of 2011-06-12 21:02:54 -0400:
> Chris Mason <chris.mason@oracle.com> writes:
> 
> > Hi everyone,
> >
> > The for-linus branch of the btrfs unstable tree:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git for-linus
> 
> >
> > Has our current queue of fixes.  Josef's is the biggest pile, mostly in
> > the allocator.  Josef and I both managed to merge his patch to avoid
> > mapping the extent buffer if skip_locking was set, git merge is just a
> > little too easy sometimes (I double checked the resulting code).
> 
> The new in 3.0 btrfs warnings on every build are still there:
> 
> fs/btrfs/sysfs.c:76: warning: ‘btrfs_root_attrs’ defined but not used
> fs/btrfs/sysfs.c:97: warning: ‘btrfs_super_attrs’ defined but not used
> fs/btrfs/sysfs.c:153: warning: ‘btrfs_super_release’ defined but not used   
> fs/btrfs/sysfs.c:160: warning: ‘btrfs_root_release’ defined but not used
> 
> These are not even used inside any ifdef. It's unclear to me: were
> these supposed to be used or removed?
> 
> Probably better to remove since they seem to be untested, unless
> it was a merge error?

Right, I've been trying to decide how much of the sysfs interface to rip
out.  We're not using it the way I had planned to, and Kay's proposed
udev changes are better than my original plans for sysfs.

One way or another I'll kill these off in the next rc.

-chris
