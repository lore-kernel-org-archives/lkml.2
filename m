Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab0LOUOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 15:14:11 -0500
Received: from mga14.intel.com ([143.182.124.37]:5800 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754952Ab0LOUOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 15:14:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,350,1288594800"; 
   d="scan'208";a="362217863"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        "John Fastabend" <john.r.fastabend@intel.com>,
        "Xinan Tang" <xinan.tang@intel.com>,
        "Junchang Wang" <junchangwang@gmail.com>
Cc: "netdev" <netdev@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 0/3] Kernel interfaces for multiqueue aware socket
Date: Wed, 15 Dec 2010 12:02:03 -0800
Message-Id: <cover.1292405004.git.fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

This patch set implements a kernel ioctl interfaces for multiqueue aware socket.
We hope network applications can use the interfaces to get ride of serialized
packet assembling kernel processing and take advantage of multiqueue feature to
handle packets in parallel.

Fenghua Yu (3):
  Kernel interfaces for multiqueue aware socket
  net/packet/af_packet.c: implement multiqueue aware socket in
    af_apcket
  drivers/net/ixgbe/ixgbe_main.c: get tx queue mapping specified in
    socket

 drivers/net/ixgbe/ixgbe_main.c |    9 +++-
 include/linux/sockios.h        |    7 +++
 include/net/sock.h             |   18 +++++++
 net/core/sock.c                |    4 +-
 net/packet/af_packet.c         |  109 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 145 insertions(+), 2 deletions(-)

