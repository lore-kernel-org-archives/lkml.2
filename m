Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab1CQOEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 10:04:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab1CQOEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 10:04:52 -0400
Date: Thu, 17 Mar 2011 16:04:04 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        jasowang@redhat.com, krkumar2@in.ibm.com, mst@redhat.com
Subject: [PULL net-2.6] vhost: cleanups and fixes
Message-ID: <20110317140403.GA16390@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following tree has fixes for vhost-net for 2.6.39.
These are easier to apply on top of Jason's and Krishna's
cleanups, and they got tested this way, so I thought it's
better for everyone to include that, and the trivial
copy_from_user optimization.

But if you think it's too late for that, pls let me know
and I'll try to untangle that dependency.

Thanks!

The following changes since commit 1fc050a13473348f5c439de2bb41c8e92dba5588:

  ipv4: Cache source address in nexthop entries. (2011-03-07 20:54:48 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost-net-next

Jason Wang (3):
      vhost-net: check the support of mergeable buffer outside the receive loop
      vhost-net: Unify the code of mergeable and big buffer handling
      vhost: lock receive queue, not the socket

Krishna Kumar (1):
      vhost: Cleanup vhost.c and net.c

Michael S. Tsirkin (2):
      vhost: copy_from_user -> __copy_from_user
      vhost-net: remove unlocked use of receive_queue

 drivers/vhost/net.c   |  159 ++++++++-----------------------------------------
 drivers/vhost/vhost.c |   55 ++++++++++++-----
 2 files changed, 64 insertions(+), 150 deletions(-)
