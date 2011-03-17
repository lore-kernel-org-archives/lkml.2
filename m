Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab1CQVzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 17:55:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45959 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018Ab1CQVyr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 17:54:47 -0400
MIME-Version: 1.0
Message-ID: <8f9abe6c-7e75-4c59-9b19-2384c1110049@default>
Date: Thu, 17 Mar 2011 14:54:09 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] mm/vfs/fs:cleancache for 2.6.39 merge window (per akpm
 approval)
References: <f22d0c67-d3e1-4d81-9f47-64b0f811cf20@default>
 <20110317114347.2416c6aa.akpm@linux-foundation.org>
 <30bf613e-e6fd-4b7f-8a8d-47838a3ea6f1@default
 20110317124722.10fd71ab.akpm@linux-foundation.org>
In-Reply-To: <20110317124722.10fd71ab.akpm@linux-foundation.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6550.5003]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D828304.00DF,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Sent: Thursday, March 17, 2011 1:47 PM
> To: Dan Magenheimer
> Subject: Re: PING**2: cleancache and 2.6.39 window?
> 
> Oh well, you may as well send a pull request to Linus then.  Please cc
> me on it.

Hi Linus --

Per offlist discussion with and the above approval from Andrew,
please pull:

git://git.kernel.org/pub/scm/linux/kernel/git/djm/tmem.git for-linus

since git commit cb655d0f3d57c23db51b981648e452988c0223f9:
Linus Torvalds (1):

    Linux 2.6.36-rc7

There are four trivial merge conflicts that Stephen Rothwell
has been carrying in linux-next, but I'm still an idiot with git
so am more likely to break something than successfully merge/rebase
and resolve these to your satisfaction.  Hope that's OK...

(And, in case of lingering concerns about cleancache, the hooks
in core code total 41 lines, were written by Chris Mason in
August 2008, and have not changed semantically since then,
so are very stable.  And there is now in 2.6.39 another
in-kernel-non-virtualization user in-tree -- drivers/staging/zcache
with more users in development to be discussed at LSF/MM.)

Thanks,
Dan

==========================

Dan Magenheimer (9):
      mm/fs: cleancache documentation
      fs: add field to superblock to support cleancache
      mm: cleancache core ops functions and config
      mm/fs: add hooks to support cleancache
      ext3: add cleancache support
      btrfs: add cleancache support
      ext4: add cleancache support
      ocfs2: add cleancache support
      xen: cleancache shim to Xen Transcendent Memory

 .../ABI/testing/sysfs-kernel-mm-cleancache         |   11 +
 Documentation/vm/cleancache.txt                    |  267 ++++++++++++++++++++
 arch/x86/include/asm/xen/hypercall.h               |    7 +
 drivers/xen/Makefile                               |    1 +
 drivers/xen/tmem.c                                 |  264 +++++++++++++++++++
 fs/btrfs/extent_io.c                               |    9 +
 fs/btrfs/super.c                                   |    2 +
 fs/buffer.c                                        |    5 +
 fs/ext3/super.c                                    |    2 +
 fs/ext4/super.c                                    |    2 +
 fs/mpage.c                                         |    7 +
 fs/ocfs2/super.c                                   |    2 +
 fs/super.c                                         |    3 +
 include/linux/cleancache.h                         |  118 +++++++++
 include/linux/fs.h                                 |    5 +
 include/xen/interface/xen.h                        |   22 ++
 mm/Kconfig                                         |   22 ++
 mm/Makefile                                        |    1 +
 mm/cleancache.c                                    |  245 ++++++++++++++++++
 mm/filemap.c                                       |   11 +
 mm/truncate.c                                      |   10 +
 21 files changed, 1016 insertions(+), 0 deletions(-)
