Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079Ab2FVUMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 16:12:20 -0400
Received: from cobra.newdream.net ([66.33.216.30]:45282 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab2FVUMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 16:12:19 -0400
Date: Fri, 22 Jun 2012 13:12:14 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for -rc4
Message-ID: <Pine.LNX.4.64.1206221303480.4806@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph fixes from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

There are a couple of fixes from Yan for bad pointer dereferences in the 
messenger code and when fiddling with page->private after page migration, 
a fix from Alex for a use-after-free in the osd client code, and a couple 
fixes for the message refcounting and shutdown ordering.

Thanks!
sage


----------------------------------------------------------------
Alex Elder (1):
      libceph: osd_client: don't drop reply reference too early

Sage Weil (2):
      libceph: use con get/put ops from osd_client
      libceph: flush msgr queue during mon_client shutdown

Yan, Zheng (2):
      ceph: check PG_Private flag before accessing page->private
      rbd: Clear ceph_msg->bio_iter for retransmitted message

 fs/ceph/addr.c         |   21 ++++++++++++---------
 net/ceph/ceph_common.c |    7 -------
 net/ceph/messenger.c   |    4 ++++
 net/ceph/mon_client.c  |    8 ++++++++
 net/ceph/osd_client.c  |   12 ++++++------
 5 files changed, 30 insertions(+), 22 deletions(-)
