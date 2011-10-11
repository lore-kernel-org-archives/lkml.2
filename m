Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab1JKTyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 15:54:22 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:59967 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933Ab1JKTyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 15:54:20 -0400
Date: Tue, 11 Oct 2011 15:54:14 -0400 (EDT)
Message-Id: <20111011.155414.810541217087355148.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 11 Oct 2011 12:54:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just a few driver bugs, and one missing state update during ipv6 GRO processing.

1) When iSCSI and FCOE are both in use, bnx2x allocated conflicting client IDs.
   Fix from Dmitry Kravkov.

2) MSCAN CAN driver copies one byte to many on odd packet lengths, fix from
   Wolfgang Grandegger.

3) Blue frame support in mlx4_en driver is busted on PowerPC due to endian
   bugs, fix from Thadeu Lima de Souza Cascardo.

4) When GRO pulls ipv6 extension headers, the protocol value changes,
   so it has to reload the protocol ops pointer.  Fix from Zheng Yan.

Please pull, thanks a lot!

The following changes since commit 65112dccf8a113737684366349d7f9ec373ddc47:

  Merge git://git.samba.org/sfrench/cifs-2.6 (2011-10-10 14:53:11 +1200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master

Dmitry Kravkov (1):
      bnx2x: fix cl_id allocation for non-eth clients for NPAR mode

Thadeu Lima de Souza Cascardo (1):
      mlx4_en: fix endianness with blue frame support

Wolfgang Grandegger (1):
      mscan: too much data copied to CAN frame due to 16 bit accesses

Yan, Zheng (1):
      gro: refetch inet6_protos[] after pulling ext headers

 drivers/net/bnx2x/bnx2x.h     |   20 +++++++++++++-------
 drivers/net/bnx2x/bnx2x_cmn.h |    2 +-
 drivers/net/can/mscan/mscan.c |   11 ++++++++---
 drivers/net/mlx4/en_tx.c      |    6 +++---
 net/ipv6/af_inet6.c           |    1 +
 5 files changed, 26 insertions(+), 14 deletions(-)
