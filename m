Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab0EJR03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 13:26:29 -0400
Received: from mail.gmx.net ([213.165.64.20]:49280 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751248Ab0EJR02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 13:26:28 -0400
Cc: akpm@osdl.org, trond.myklebust@fys.uio.no, riel@redhat.com, major@mhtx.net
Content-Type: text/plain; charset="utf-8"
Date: Mon, 10 May 2010 19:26:21 +0200
From: "Alexander Stohr" <Alexander.Stohr@gmx.de>
Message-ID: <20100510172621.284310@gmx.net>
MIME-Version: 1.0
Subject: Re: [BUG?] vfs_cache_pressure=0 does not free inode caches
To: linux-kernel@vger.kernel.org
X-Authenticated: #15156664
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19MizoVy7FM+1mbvA8i6XYs54hF5mticP2K3SLtuQ
 ZdScMx8wCy3a6Lj/DNUuqMKRBjwvAMUx/Y+Q== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: hXPbf2UmX1V6K4woi2FyIvZ/SDc4NMy9
X-FuHaFi: 0.59999999999999998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this is a follow up to:
http://lkml.indiana.edu/hypermail/linux/kernel/0904.1/03026.html

> The server is going to die a slow death,
> all user space memory is swapped out,
> then all processes are OOM killed 
> until it dies from complete memory exhaustion."

> a cache is supposed to be a cache and not a memory hog

i'm running an embedded system with NFS as my working area.
the system has only few ram leftover, any MiBi counts.

my current best guess to resolve low memory situations
is a manual one (no, i could not see any smart kernel reaction
with that relatively old but patched 2.6.18 kernel) is this:

echo 100000 >/proc/sys/vm/vfs_cache_pressure
sync
echo 1 >/proc/sys/vm/drop_caches
echo 2 >/proc/sys/vm/drop_caches

any hints on that?
is this still an issue in current kernels
or is this already addressed in some way?

regards, Alex.


here is the link to the initial patch set applied to 2.6.8:
http://git.kernel.org/?p=linux/kernel/git/torvalds/old-2.6-bkcvs.git;a=commit;h=95afb3658a8217ff2c262e202601340323ef2803

some other people spotting similar effects:
http://rackerhacker.com/2008/12/03/reducing-inode-and-dentry-caches-to-keep-oom-killer-at-bay/
-- 
GRATIS für alle GMX-Mitglieder: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://portal.gmx.net/de/go/maxdome01
