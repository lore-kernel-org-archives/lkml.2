Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab2AICMM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 21:12:12 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48487 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab2AICML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 21:12:11 -0500
Date: Mon, 9 Jan 2012 02:12:06 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <mszeredi@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [git pull] vfs pile 1
Message-ID: <20120109021206.GU23916@ZenIV.linux.org.uk>
References: <20120105022318.GG23916@ZenIV.linux.org.uk>
 <CA+55aFw+7xvfP3NCr5p2Ma--UTb7zT+QQxtjCn3V2SU_g3LUdA@mail.gmail.com>
 <20120108235039.GQ23916@ZenIV.linux.org.uk>
 <20120108235338.GR23916@ZenIV.linux.org.uk>
 <CA+55aFzqfne7xs-M3qkZYs=wFmCJBL43AFcywRg3dc1S=8qK6A@mail.gmail.com>
 <20120109002526.GS23916@ZenIV.linux.org.uk>
 <CA+55aFyoUokxXEU7QDMxyXEss9Xp-XsY-cz1QPC442xZKcuXjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyoUokxXEU7QDMxyXEss9Xp-XsY-cz1QPC442xZKcuXjg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 08, 2012 at 04:39:20PM -0800, Linus Torvalds wrote:
> On Sun, Jan 8, 2012 at 4:25 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Sure, will do. ?I have several more fixes in my tree right now (including
> > such gems as double kfree() in devpts on mount failure ;-/), so I'll send
> > a pull request in a couple of hours anyway. ?Would you be OK with having
> > that patch in the same pile?
> 
> Sure, no problem.

OK, there we go, then...  This stuff is fixes-only; there'll be another
pile with patches from various folks all over the last cycle.  Please,
pull from the usual place -
git://git.kernel.org:/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (5):
      functionfs: unfuck failure exits on mount
      ... and the same for gadgetfs
      devpts: fix double-free on mount failure
      exofs: oops after late failure in mount
      ext[34]: avoid i_nlink warnings triggered by drop_nlink/inc_nlink kludge in symlink()

Diffstat:
 drivers/usb/gadget/f_fs.c  |   31 +++++++++++--------------------
 drivers/usb/gadget/inode.c |   26 +++++++++++---------------
 fs/devpts/inode.c          |    4 +---
 fs/exofs/super.c           |    2 ++
 fs/ext3/namei.c            |    2 +-
 fs/ext4/namei.c            |    2 +-
 6 files changed, 27 insertions(+), 40 deletions(-)

