Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab0DNSa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 14:30:26 -0400
Received: from cobra.newdream.net ([66.33.216.30]:36977 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461Ab0DNSaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 14:30:24 -0400
Date: Wed, 14 Apr 2010 11:32:23 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: Re: [GIT PULL] ceph fixes for 2.6.34-rc5
In-Reply-To: <Pine.LNX.4.64.1004141121320.10273@cobra.newdream.net>
Message-ID: <Pine.LNX.4.64.1004141130590.10273@cobra.newdream.net>
References: <Pine.LNX.4.64.1004141121320.10273@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Apr 2010, Sage Weil wrote:
> Please pull the following ceph bug fixes from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

Whoops, I missed one patch in there that fixes a lockdep false positive.  
The updated shortlog is below.

Thanks-
sage


Sage Weil (9):
      ceph: fix dentry rehashing on virtual .snap dir
      ceph: allow writeback of snapped pages older than 'oldest' snapc
      ceph: fix snap context reference leaks
      ceph: fix leaked inode ref due to snap metadata writeback race
      ceph: fix ack counter reset on connection reset
      ceph: decode v5 of osdmap (pool names) [protocol change]
      ceph: fix dentry reference leak in dcache readdir
      ceph: queue_cap_snap should always queue dirty context
      ceph: use separate class for ceph sockets' sk_lock

Yehuda Sadeh (1):
      ceph: reserve one more caps space when doing readdir

 fs/ceph/addr.c      |   62 +++++++++---------
 fs/ceph/caps.c      |   42 +++++++++---
 fs/ceph/dir.c       |    7 +-
 fs/ceph/inode.c     |   10 +++-
 fs/ceph/messenger.c |    9 +++
 fs/ceph/osdmap.c    |  180 +++++++++++++++++++++++++++++++--------------------
 fs/ceph/osdmap.h    |    1 +
 fs/ceph/rados.h     |    6 +-
 fs/ceph/snap.c      |   26 ++++----
 fs/ceph/super.h     |    3 +-
 10 files changed, 212 insertions(+), 134 deletions(-)
