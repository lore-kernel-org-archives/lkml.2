Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab1D1Rav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 13:30:51 -0400
Received: from trent.utfs.org ([194.246.123.103]:44795 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310Ab1D1Rat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 13:30:49 -0400
Date: Thu, 28 Apr 2011 10:30:47 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Dave Chinner <david@fromorbit.com>
cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <20110427102824.GI12436@dastard>
Message-ID: <alpine.DEB.2.01.1104281008320.18728@trent.utfs.org>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org> <20110424234655.GC12436@dastard> <alpine.DEB.2.01.1104242245090.18728@trent.utfs.org> <alpine.DEB.2.01.1104250015480.18728@trent.utfs.org> <20110427022655.GE12436@dastard>
 <alpine.DEB.2.01.1104270042510.18728@trent.utfs.org> <20110427102824.GI12436@dastard>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

sorry for the late response:

On Wed, 27 Apr 2011 at 20:28, Dave Chinner wrote:
> hmmmm. Speaking of which - have you changed any of the XFS tunables
> in /proc/sys/fs/xfs/ on your machine (specifically
> xfssyncd_centisecs)?

No, I did not change anything underneath /proc/sys/fs/xfs.
 
> Not easy because there are tree-wide changes that need to be
> preserved (e.g. block layer plugging changes) while others around it
> would need to be reverted....

Yeah, I noticed. I wanted to do something like this:

  $ for c in `git log --pretty=oneline --no-merges v2.6.38..v2.6.39-rc2 fs/xfs | awk '{print $1}'`; do
       git revert $c
    done

...but this broke on the 1st or 2nd commit because of unresolved changes.

Now I'm in the middle of another bisect attempt, trying to reproduce but 
Im getting (probably totally unrelated) warnings here:

BUG: sleeping function called from invalid context at /usr/local/src/linux-2.6-git/drivers/ide/ide-io.c:447
in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper
INFO: lockdep is turned off.
[...]
 
> Can you check if there are any blocked tasks nearing OOM (i.e. "echo
> w > /proc/sysrq-trigger") so we can see if XFS inode reclaim is
> stuck somewhere?

In one instance when I mounted with "noatime", no log messages made it to 
the disk, but I could see "hung tasks":

   http://nerdbynature.de/bits/2.6.39-rc4/oom/oom-6.JPG

I will try sysrq-w later on.

FWIW, a regression bug has been opened:

  https://bugzilla.kernel.org/show_bug.cgi?id=34012

Thanks,
Christian.
-- 
BOFH excuse #284:

Electrons on a bender
