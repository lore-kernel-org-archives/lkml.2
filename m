Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab1AEKZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 05:25:45 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:12853 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752025Ab1AEKZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 05:25:42 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAAfWI015Ldpx/2dsb2JhbACkJHS/CoVMBIUk
Date: Wed, 5 Jan 2011 21:25:34 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [announce] vfs-scale git tree update
Message-ID: <20110105102534.GA6679@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Git tree is here:
  
  git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git
  
Branch is:

    vfs-scale-working

Changes since last posting:
* Updated to 2.6.37 (Documentation/filesystems/Locking clash)
* Switch names of vfsmount scalable counter helpers suggested by Andreas
* Most significant are changes in Documentation/filesystems/path-lookup.txt
  attempt to make it more readable, consistent and informative. Add some
  interesting rcu-walk path lookup success and behaviour statistics.

Status:
* Linus is planning to merge. It's never too late for review, though.
* linux-next has been uneventful, but I don't think it nearly covers all
  interesting and fiddly use cases.
* Still has the barrier-less __seqcount optimisation that Linus didn't
  like; I like the idea of a seqcount-switch API, but it just didn't
  seem to fit well here. Let's leave that on the todo list?

Future dcache / name lookup work:
* Per-zone LRUs. Patch is simple and ready, but performance bisecting
  might be a bit easier if we hold off. Also inode LRUs should be done at
  the same time.
* Filesystems will need to start implementing rcu-walk aware dentry
  and permission ops. They've got simple examples to follow.
* Rename scaling. The rename seqlock can explode on large systems,
  getting into strange conditions where lookup performance crashes.
  It is also a global lock for renames. Quite simple to break it up and
  fix lookup performance and provide linear vfs scalability for parallel
  same-directory renames (if they are in different directories). Doesn't
  need to be merged yet, though.
* Further optimise name string copying and comparison (may be as much as
  10-20% in that).
* rcu-walk for symlinks. A bit tricky, not impossible.

