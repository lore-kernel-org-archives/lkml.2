Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab1LVHJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 02:09:15 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:54027 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab1LVHJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 02:09:13 -0500
Date: Thu, 22 Dec 2011 07:09:12 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] fix for nasty races in br_write_lock()
Message-ID: <20111222070912.GL23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	There's a nasty race between CPU hotplug and br_write_lock();
the latter pretty much assumes that the set of online CPUs can't change
between br_write_lock() and br_write_unlock().  Caught by Cong Meng,
solution hashed out during the last few days between me and Srivatsa S. Bhat
on l-k/fsdevel thread, appears to fix the problem in a reasonably sane
way.  It'll need to go into -stable as well; all branches since 2.6.36.
Please, pull from the usual place;
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Srivatsa S. Bhat (1):
      VFS: Fix race between CPU hotplug and lglocks

Diffstat:
 include/linux/lglock.h |   36 ++++++++++++++++++++++++++++++++----
 1 files changed, 32 insertions(+), 4 deletions(-)
