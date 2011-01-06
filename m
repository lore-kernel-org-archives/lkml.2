Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab1AFEmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 23:42:42 -0500
Received: from home.kolivas.org ([59.167.196.135]:34032 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab1AFEml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 23:42:41 -0500
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] BFS cpu scheduler v0.363 for 2.6.37
Date: Thu, 6 Jan 2011 15:42:37 +1100
User-Agent: KMail/1.13.5 (Linux/2.6.37-ck1; KDE/4.4.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101061542.37725.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BFS (name shall not be said for PG requirements) CPU scheduler for 2.6.37 
is now available.

Since the last release, a lot more work was put into maintaining fine grained 
accounting at all times (which should help on 32 bit machines, uniprocessor 
and 100Hz configs), minor changes have been made to make CPU offline code more 
robust for the purposes of suspend to ram/disk, and some small scalability 
improvements were added for SMT CPUs (eg i7). These changes are unlikely to 
have dramatically noticeable effects unless you were already experiencing a 
problem or poor performance.

A direct link to the patch for 2.6.37 is here:
http://ck.kolivas.org/patches/bfs/2.6.37/2.6.37-sched-bfs-363.patch

All BFS patches here:
http://ck.kolivas.org/patches/bfs

Version 363 has been ported to 2.6.35 and 2.6.32 and available from that 
directory in lieu of the long term release nature of these kernels.


On a related note, a small multi-user server feature request was commissioned 
for BFS that I was happy to work on, which I'd like to also make publicly 
available.

Here is the changelog:

---

Make it possible to proportion CPU resource strictly according to user ID by
grouping all tasks from the one user as one task.

This is done through simply tracking how many tasks from the one UID are
running at any one time and using that data to determine what the virtual
deadline is, offset by proportionately more according to the number of running
tasks. Do this by creating an array of every UID for very quick lookup of the
running value and protect it by the grq lock. This should incur almost
immeasurably small overhead even when enabled. An upper limit of 65535 UIDs
is currently supported.

Make this feature configurable at build time and runtime via Kconfig, and
through the use of sysctls

/proc/sys/kernel/group_by_uid
to enable or disable the feature (default 1 == on), and

/proc/sys/kernel/group_uid_min
to decide the minimum uid to group tasks from (default 1000)

Nice values are still respected, making it possible to allocate different
amounts of CPU to each user.

This feature is most suited to a multi-user shell type server environment and
is NOT recommended for an ordinary desktop.

---
The patch is available for the moment here:
http://ck.kolivas.org/patches/bfs/test/bfs363-group_uids.patch


A reminder that this is NOT a desktop, laptop or embedded device type feature. 
The purpose of this feature is to make it impossible for any one user to get 
more CPU than any other user on a multi-user login. This is suitable for 
multiuser shared GUI/X session or shell type machines, and incurs almost 
negligible overhead.


I'll be offline shortly for a few weeks so I'll be unlikely to respond to any 
emails till I return.


Enjoy,
Con

-- 
-ck
