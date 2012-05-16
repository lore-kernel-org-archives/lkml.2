Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759159Ab2EPVgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 17:36:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757373Ab2EPVgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 17:36:05 -0400
Date: Thu, 17 May 2012 00:15:49 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, davem@davemloft.net
Subject: [PATCHv2-RFC 0/6] tun zerocopy support
Message-ID: <cover.1337202879.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So this still triggers some failures under stress
but I thought it might be helpful to post here
since people expressed interest.

This uses some patches from Ian's patchset
to support zerocopy with tun.
We are still trying to figure out how to make
everything work properly with tcp but tun seems
easier, and it's helpful since not everyone can
use macvtap.

There's some code duplication between tun and macvtap
now: common code could move to net/core/datagram.c,
this patch does not do this yet.

-- 
MST


Michael S. Tsirkin (6):
  skbuff: add an api to orphan frags
  skbuff: convert to skb_orphan_frags
  skbuff: export skb_copy_ubufs
  tun: orphan frags on xmit
  net: orphan frags on receive
  tun: experimental zero copy tx support

 drivers/net/tun.c      |  134 ++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/skbuff.h |   16 ++++++
 net/core/dev.c         |    2 +
 net/core/skbuff.c      |   24 +++-----
 4 files changed, 156 insertions(+), 20 deletions(-)

-- 
MST
