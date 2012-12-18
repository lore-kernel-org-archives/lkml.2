Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab2LRUSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 15:18:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678Ab2LRUST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 15:18:19 -0500
From: Luiz Capitulino <lcapitulino@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, aquini@redhat.com,
        mst@redhat.com, amit.shah@redhat.com, agl@us.ibm.com
Subject: [RFC 0/2] auto-ballooning prototype (guest part)
Date: Tue, 18 Dec 2012 18:17:28 -0200
Message-Id: <1355861850-2702-1-git-send-email-lcapitulino@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series implements an early protoype of a new feature called
automatic ballooning. This is based on ideas by Rik van Riel and
I also got some help from Rafael Aquini (misconceptions and bugs
are all mine, though).

The auto-ballooning feature automatically performs balloon inflate
and deflate based on host and guest memory pressure. This can help
to avoid swapping or worse in both, host and guest.

This series implements the guest part. Full details on the design
and implementation can be found in patch 2/2.

To test this you will also need the host part, which can be found
here (please, never mind the repo name):

 git://repo.or.cz/qemu/qmp-unstable.git balloon/auto-ballooning/rfc

Any feedback is appreciated!

Luiz Capitulino (2):
  virtio_balloon: move locking to the balloon thread
  virtio_balloon: add auto-ballooning support

 drivers/virtio/virtio_balloon.c     | 60 ++++++++++++++++++++++++++++++++++---
 include/uapi/linux/virtio_balloon.h |  1 +
 2 files changed, 57 insertions(+), 4 deletions(-)

-- 
1.8.0
