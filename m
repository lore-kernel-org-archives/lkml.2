Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933378Ab2AJBet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 20:34:49 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42075 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932525Ab2AJBep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 20:34:45 -0500
Date: Tue, 10 Jan 2012 01:34:34 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
        Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, gregkh@suse.de,
        akpm@linux-foundation.org
Subject: Re: [RFC PATCH] shrink_dcache_parent() deadlock
Message-ID: <20120110013434.GA23916@ZenIV.linux.org.uk>
References: <87ipkl87m9.fsf@tucsk.pomaz.szeredi.hu>
 <20120109171639.GA9359@infradead.org>
 <20120109173010.GX23916@ZenIV.linux.org.uk>
 <CA+55aFwikQQrpGoyxvY+y=B8NfKBSdcAnKME+xZh+N1TQfp8LA@mail.gmail.com>
 <20120109205907.GE4198@dastard>
 <CA+55aFxN+Yh_M=P8cVbGcuHGo+PgcXm1bOFAJQ-5_euqU9LOww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxN+Yh_M=P8cVbGcuHGo+PgcXm1bOFAJQ-5_euqU9LOww@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 01:21:43PM -0800, Linus Torvalds wrote:
> So I'll happily add my signed-off on that code if Al wants to take
> that edited patch into his tree. Or just commit it directly.

It's there.  The usual place, i.e.
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (4):
      isofs: inode leak on mount failure
      ext4: fix failure exits
      ceph: d_alloc_root() may fail
      vfs: new helper - d_make_root()

Dave Chinner (1):
      dcache: use a dispose list in select_parent

Diffstat:
 fs/ceph/super.c        |   15 ++++++--
 fs/dcache.c            |   80 +++++++++++++++++++++++-------------------------
 fs/ext4/super.c        |   13 +++++---
 fs/isofs/inode.c       |    7 +++-
 include/linux/dcache.h |    1 +
 5 files changed, 63 insertions(+), 53 deletions(-)
