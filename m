Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab1LWRZD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 12:25:03 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:29592 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab1LWRY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 12:24:59 -0500
Date: Fri, 23 Dec 2011 12:24:54 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs fixes
Message-ID: <20111223172454.GT19266@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4EF4B969.0110,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

My for-linus branch has two commits:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

One is Al's patch in response to my last pull request, but with one small
change to call d_instantiate before trying to log the inode in
btrfs_link.

The other is a double unlock that Dan Carpenter found.  These did get
rebased this morning before I pushed them out, but I reran tests after
the rebase.

Chris Mason (1) commits (+2/-1):
    Btrfs: fix worker lock misuse in find_worker

Al Viro (1) commits (+5/-4):
    Btrfs: call d_instantiate after all ops are setup

Total: (2) commits (+7/-5)

 fs/btrfs/async-thread.c |    3 ++-
 fs/btrfs/inode.c        |    9 +++++----
 2 files changed, 7 insertions(+), 5 deletions(-)
