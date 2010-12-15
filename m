Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab0LPC1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 21:27:13 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:54662 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755129Ab0LPC1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 21:27:10 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAIYHCU15Lc+z/2dsb2JhbACkM3TBfIVKBIUf
Date: Wed, 15 Dec 2010 21:22:26 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [announce] rcu-walk and dcache scaling tree update
Message-ID: <20101215102226.GA9093@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm rebasing the tree, because I don't expect anybody to be basing
downstream work on it, I hope that doesn't cause anybody pain.

Git tree is here:

  git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git

Branch is:

    vfs-scale-working

Changes since last posting:
* Added mntget/mntput scaling patch. I think this is important for
  testers because it significantly increases parallelism through the
  dcache and path walk. So both performance and races will get better
  test coverage.
* Missing vfs.txt documentation for new _rcu dentry and inode ops.
* Large improvements to Documentation/filesystems/path-walk.txt
* Improved some changelogs
* Added AMD fam10h numbers to ``memcmp optimisation'' changelog, and
  Westmere numbers to ``prefetch inode'' optimisation changelog. The
  AMD doesn't get such a big boost as the Intel CPU when avoiding rep
  cmp, but does get a small improvement.

Thanks,
Nick

