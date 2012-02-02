Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab2BBVY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:24:59 -0500
Received: from cobra.newdream.net ([66.33.216.30]:42564 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097Ab2BBVY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:24:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:message-id:mime-version:content-type; q=dns; s=
	newdream.net; b=10VTgzQAXPz5gTAb23YnweOXJd8UCR4gyIpWAUdPRbmGo4Q3
	4gbij3WBmyXZgZYl4EgHgIKxNWtl87VDlQf0DVoC9pZJ8UilFWvG6HNoL3IyzZN8
	odiwEMDVRiU1PErNxgPmtmWWsNNd/b9/ntxOtC7kZMvjlGs/b3S302/Xuno=
Date: Thu, 2 Feb 2012 13:24:57 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for -rc3
Message-ID: <Pine.LNX.4.64.1202021321160.14628@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph fixes from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

There are fixes for a misnamed xattr, a deadlock that lockdep turned up, a 
missing decode check, and some miscellaneous leaks and races.

Thanks!
sage


Alex Elder (4):
      ceph: change "ceph.layout" xattr to be "ceph.file.layout"
      ceph: create a new session lock to avoid lock inversion
      rbd: fix a memory leak in rbd_get_client()
      rbd: fix safety of rbd_put_client()

Sage Weil (1):
      ceph: initialize client debugfs outside of monc->mutex

Xi Wang (1):
      ceph: fix length validation in parse_reply_info()

 drivers/block/rbd.c    |    7 +++++--
 fs/ceph/caps.c         |    4 ++--
 fs/ceph/dir.c          |    4 ++--
 fs/ceph/mds_client.c   |   10 +++++++---
 fs/ceph/mds_client.h   |    7 +++++--
 fs/ceph/xattr.c        |    4 +++-
 net/ceph/ceph_common.c |    2 --
 net/ceph/mon_client.c  |   13 ++++++++++++-
 8 files changed, 36 insertions(+), 15 deletions(-)
