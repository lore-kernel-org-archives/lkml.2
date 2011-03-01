Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab1CAFGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 00:06:15 -0500
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.104]:29420
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750772Ab1CAFGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 00:06:14 -0500
X-Greylist: delayed 558 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Mar 2011 00:06:13 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAKYLbE18qV3C/2dsb2JhbACEJ6IjdKookHSBJ4FXgW12BIUQimc
X-IronPort-AV: E=Sophos;i="4.62,245,1297008000"; 
   d="scan'208";a="637553851"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 0/4] more on vfs-scale and vfs-automount
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Nick Piggin <npiggin@gmail.com>, David Howells <dhowells@redhat.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 01 Mar 2011 12:56:50 +0800
Message-ID: <20110301044457.4615.40333.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've put quite a bit of time into testing 2.6.38-rc and, given the
time frame, and update is needed. The included patch series much
improves the behaviour of autofs under load.

I first thought the dentry leak you found was not the cause of the
BUG() I was seeing but that appears to not be the case. I'm not
seeing the BUG() at shutdown when umounting any more.

I am still seeing occassional incorrect ENOENT returns. They must be
comming from the VFS or the daemon as I've changed almost all the
ENOENT returns in the autofs module to identify where it's comming
from.

Anyway, all, please review.

---

Ian Kent (4):
      autofs4 - fix autofs4_expire_indirect() traversal
      autofs4 - fix dentry leak in autofs4_expire_direct()
      autofs4 - fix rootless multi-mount race
      vfs - check non-mountpoint dentry might block in __follow_mount_rcu()


 fs/autofs4/expire.c |   72 ++++++++++++++++++++++++++++++++++++++++-----------
 fs/autofs4/root.c   |   20 +++-----------
 fs/namei.c          |   24 ++++++++++++++---
 3 files changed, 80 insertions(+), 36 deletions(-)

-- 
Ian
