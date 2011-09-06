Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab1IFNnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 09:43:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35525 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab1IFNnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 09:43:05 -0400
MIME-Version: 1.0
From: Eric Van Hensbergen <ericvh@gmail.com>
Date: Tue, 6 Sep 2011 08:42:44 -0500
Message-ID: <CAFkjPTmqABteR=n3x+AVnmn4JZBjsf1EHBvKXkGmv4zK=nUqAw@mail.gmail.com>
Subject: [GIT PULL] v9fs fixes for 3.1-rc6
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: V9FS Developers <v9fs-developer@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(also sent as a github internal pull-request for fun)

First off, let me apologize.  Vacations and kernel.org disruptions
have delayed me from getting you these bug fixes sooner in the cycle.
Beyond the typical bug fixes, there are a couple of protocol "bugs"
fixed here dealing with lack of foresight in developing some of the
new protocol extensions that we wanted to fix as soon as possible.

Thanks.

The following changes since commit ddf28352b80c86754a6424e3a61e8bdf9213b3c7:

  Linux 3.1-rc5 (2011-09-04 15:45:10 -0700)

are available in the git repository at:
  git://github.com/ericvh/linux.git for-linus

Aneesh Kumar K.V (5):
      fs/9p: Add fid before dentry instantiation
      fs/9p: Don't update file type when updating file attributes
      net/9p: Fix kernel crash with msize 512K
      fs/9p: Add OS dependent open flags in 9p protocol
      fs/9p: Always ask new inode in lookup for cache mode disabled

Jim Garlick (1):
      fs/9p: Use protocol-defined value for lock/getlock 'type' field.

 fs/9p/v9fs_vfs.h       |    6 ++-
 fs/9p/vfs_file.c       |   36 ++++++++++---
 fs/9p/vfs_inode.c      |  139 ++++++++++++++++++++++++++++++------------------
 fs/9p/vfs_inode_dotl.c |   86 +++++++++++++++++++++++++-----
 fs/9p/vfs_super.c      |    2 +-
 include/net/9p/9p.h    |   29 ++++++++++
 net/9p/trans_virtio.c  |   17 ++++--
 7 files changed, 234 insertions(+), 81 deletions(-)
