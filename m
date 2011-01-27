Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab1A0WBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 17:01:54 -0500
Received: from cobra.newdream.net ([66.33.216.30]:41233 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab1A0WBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 17:01:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:message-id:mime-version:content-type; q=dns; s=
	newdream.net; b=uCi7CX7Q5Bud2dUsYf7CXmwCShQmy1lFCj5a7r/a6ftY59TI
	LcUaVGDw1NQWZQHwTkGyE9e5z89sX9uqHg4Qhz/Y4aMb46udM2KIYLdV+9YPbBUy
	0AUbnoRlfcxJFe4SjByyZPZ5zRPfGd9h1r03qo61nu3Q5SPY/2C6WS43a6c=
Date: Thu, 27 Jan 2011 14:02:24 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 2.6.38-rc3
Message-ID: <Pine.LNX.4.64.1101271358210.24057@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph fixes from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

There is an xattr search/sort fix, a number of clustered MDS fixes (for a 
sync hang, dup flushes, misdirected/lost request), and a fix for the 
norbytes option with lets users avoid EOVERFLOW on 32-bit systems.

Thanks!
sage


Sage Weil (6):
      ceph: fix xattr rbtree search
      ceph: fix cap_wanted_delay_{min,max} mount option initialization
      ceph: fix erroneous cap flush to non-auth mds
      ceph: fix flushing of caps vs cap import
      ceph: avoid immediate cap check after import
      ceph: avoid picking MDS that is not active

Yehuda Sadeh (1):
      ceph: fix getattr on directory when using norbytes

 fs/ceph/caps.c       |   43 +++++++++++++++++++++++++++++++++++++------
 fs/ceph/inode.c      |   10 +++++-----
 fs/ceph/mds_client.c |   10 +++++++---
 fs/ceph/super.c      |    2 ++
 fs/ceph/xattr.c      |    3 +++
 5 files changed, 54 insertions(+), 14 deletions(-)
