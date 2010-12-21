Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933581Ab0LUE3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 23:29:25 -0500
Received: from cobra.newdream.net ([66.33.216.30]:40420 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933461Ab0LUE3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 23:29:23 -0500
Date: Mon, 20 Dec 2010 20:34:48 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 2.6.37-rc7
Message-ID: <Pine.LNX.4.64.1012201438310.15201@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph fixes from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

There are a few fixes for direct-io reads (non-page aligned buffers, 
marking user pages dirty), two error path fixes, and the NULL dereference 
triggered by NFS export that Al pointed out.

Thanks!
sage


Henry C Chang (3):
      ceph: fix direct-io on non-page-aligned buffers
      ceph: mark user pages dirty on direct-io reads
      ceph: handle partial result from get_user_pages

Sage Weil (2):
      ceph: fix msgr_init error path
      ceph: fix null pointer dereference in ceph_init_dentry for nfs reexport

 fs/ceph/dir.c                |    3 ++-
 fs/ceph/file.c               |   39 +++++++++++++++++++++++----------------
 include/linux/ceph/libceph.h |    6 ++++--
 net/ceph/messenger.c         |    8 +++-----
 net/ceph/pagevec.c           |   15 +++++++++------
 5 files changed, 41 insertions(+), 30 deletions(-)

