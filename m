Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672Ab0E0ReE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:34:04 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:34914 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683Ab0E0ReB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:34:01 -0400
Date: Thu, 27 May 2010 13:32:20 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-btrfs@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs updates
Message-ID: <20100527173220.GG3835@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
References: <20100527151515.GA3835@think>
 <alpine.LFD.2.00.1005271014570.3689@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005271014570.3689@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090205.4BFEAD01.005C:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 10:18:04AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 27 May 2010, Chris Mason wrote:
> > 
> >  fs/btrfs/extent-tree.c  | 2317 ++++++++++++++++++++++++++++--------------------
> >  fs/btrfs/relocation.c   | 1991 +++++++++++++++++++++++++----------------
> >  fs/btrfs/inode.c        | 1797 +++++++++++++++++++++++++++++--------
> >  fs/btrfs/file.c         |  304 +++---
> >  fs/btrfs/tree-log.c     |  241 +++-
> > ...
> 
> What kind of bogus diffstat is this? 
> 
> Don't do that. I cannot compare your bogus diffstat with what I get, 
> because it's just random noise. You've apparently sorted it by size of the 
> damage, but the numbers are total crap too. That is _not_ the actual size 
> of the changes at all.

My the btrfs-unstable repo is against v2.6.34, here is a 'pure'
diffstat.  My script ends up piping the git log -p output through
diffstat, which does give different numbers.  I'll use the git diff
variant from now on.

# git diff v2.6.34 HEAD | diffstat
 fs/btrfs/async-thread.c |    1 
 fs/btrfs/btrfs_inode.h  |    3 
 fs/btrfs/ctree.c        |  109 +-
 fs/btrfs/ctree.h        |  163 ++-
 fs/btrfs/delayed-ref.c  |  101 --
 fs/btrfs/delayed-ref.h  |    3 
 fs/btrfs/disk-io.c      |  169 +--
 fs/btrfs/disk-io.h      |    4 
 fs/btrfs/extent-tree.c  | 2255 ++++++++++++++++++++++++++++--------------------
 fs/btrfs/extent_io.c    |   85 -
 fs/btrfs/extent_io.h    |   14 
 fs/btrfs/file-item.c    |   28 
 fs/btrfs/file.c         |  166 ++-
 fs/btrfs/inode-item.c   |   27 
 fs/btrfs/inode.c        | 1713 ++++++++++++++++++++++++++++--------
 fs/btrfs/ioctl.c        |  206 ++--
 fs/btrfs/ordered-data.c |   82 +
 fs/btrfs/ordered-data.h |    9 
 fs/btrfs/relocation.c   | 1971 +++++++++++++++++++++++++----------------
 fs/btrfs/root-tree.c    |   23 
 fs/btrfs/super.c        |   30 
 fs/btrfs/transaction.c  |  232 +++-
 fs/btrfs/transaction.h  |   24 
 fs/btrfs/tree-defrag.c  |    7 
 fs/btrfs/tree-log.c     |  241 +++--
 fs/btrfs/tree-log.h     |    2 
 fs/btrfs/volumes.c      |   17 
 fs/btrfs/xattr.c        |   12 
 fs/direct-io.c          |   62 +
 include/linux/fs.h      |   11 
 mm/filemap.c            |   36 
 31 files changed, 5066 insertions(+), 2740 deletions(-)

-chris
