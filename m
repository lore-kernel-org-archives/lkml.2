Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab1GRUSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 16:18:25 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49213 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab1GRUSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 16:18:24 -0400
Date: Mon, 18 Jul 2011 13:18:13 -0700 (PDT)
Message-Id: <20110718.131813.1898495363509638037.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 18 Jul 2011 13:18:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A few last-minute stragglers.  The Tulip debug message thing, in
particular, is a really annoying regression for people who have
that hardware.

1) pr_*() conversion of tulip driver turned some commented out messages
   into pr_debug() which spams the log, just kill them off.  From Joe
   Perches.

2) PPPOE connections are keyed on MAC address, so we have to flush all
   connections on a device when the MAC address changes since until we
   renegotiate with the new MAC address the remote end won't see any
   of our packets.

3) linux/sdla.h has a kernel function declaration in the userspace
   visible area.  In fact this function hasn't been in the kernel for
   years so just remove it outright.  From WANG Cong.

Please pull, thanks a lot.

The following changes since commit dc6b845044ccb7e9e6f3b7e71bd179b3cf0223b6:

  si4713-i2c: avoid potential buffer overflow on si4713 (2011-07-18 09:12:21 -0700)

are available in the git repository at:
  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

David S. Miller (1):
      pppoe: Must flush connections when MAC address changes too.

Joe Perches (1):
      tulip: dmfe: Remove old log spamming pr_debugs

WANG Cong (1):
      include/linux/sdla.h: remove the prototype of sdla()

 drivers/net/pppoe.c      |    3 ++-
 drivers/net/tulip/dmfe.c |    4 ----
 include/linux/sdla.h     |    6 +-----
 3 files changed, 3 insertions(+), 10 deletions(-)
