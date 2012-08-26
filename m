Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab2HZLZi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 07:25:38 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44928 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750734Ab2HZLZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 07:25:36 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Baron <jbaron@redhat.com>, Jim Cromie <jim.cromie@gmail.com>,
        Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] dev_<level> and dynamic_debug cleanups
Date: Sun, 26 Aug 2012 04:25:25 -0700
Message-Id: <cover.1345978012.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent commit to fix dynamic_debug was a bit unclean.
Neaten the style for dynamic_debug.
Reduce the stack use of message logging that uses netdev_printk
Add utility functions dev_printk_emit and dev_vprintk_emit for /dev/kmsg.

Joe Perches (5):
  dev_dbg/dynamic_debug: Update to use printk_emit, optimize stack
  netdev_printk/dynamic_netdev_dbg: Directly call printk_emit
  netdev_printk/netif_printk: Remove a superfluous logging colon
  dev: Add dev_vprintk_emit and dev_printk_emit
  device and dynamic_debug: Use dev_vprintk_emit and dev_printk_emit

 drivers/base/core.c       |   87 +++++++++++++++++++++++++++++---------------
 include/linux/device.h    |   17 +++++++--
 include/linux/netdevice.h |    3 --
 lib/dynamic_debug.c       |   56 ++++++++++++++++++++++-------
 net/core/dev.c            |   20 +++++++----
 5 files changed, 126 insertions(+), 57 deletions(-)

-- 
1.7.8.111.gad25c.dirty

