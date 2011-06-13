Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab1FMBEP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 21:04:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:59049 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754286Ab1FMBEO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 21:04:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,356,1304319600"; 
   d="scan'208";a="15435796"
From: Andi Kleen <andi@firstfloor.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "linux-btrfs" <linux-btrfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs updates
References: <1307879298-sup-3080@shiny>
Date: Sun, 12 Jun 2011 18:02:54 -0700
In-Reply-To: <1307879298-sup-3080@shiny> (Chris Mason's message of "Sun, 12
	Jun 2011 07:57:34 -0400")
Message-ID: <m262oar1a9.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason <chris.mason@oracle.com> writes:

> Hi everyone,
>
> The for-linus branch of the btrfs unstable tree:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git for-linus

>
> Has our current queue of fixes.  Josef's is the biggest pile, mostly in
> the allocator.  Josef and I both managed to merge his patch to avoid
> mapping the extent buffer if skip_locking was set, git merge is just a
> little too easy sometimes (I double checked the resulting code).

The new in 3.0 btrfs warnings on every build are still there:

fs/btrfs/sysfs.c:76: warning: ‘btrfs_root_attrs’ defined but not used
fs/btrfs/sysfs.c:97: warning: ‘btrfs_super_attrs’ defined but not used
fs/btrfs/sysfs.c:153: warning: ‘btrfs_super_release’ defined but not used   
fs/btrfs/sysfs.c:160: warning: ‘btrfs_root_release’ defined but not used

These are not even used inside any ifdef. It's unclear to me: were
these supposed to be used or removed?

Probably better to remove since they seem to be untested, unless
it was a merge error?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
