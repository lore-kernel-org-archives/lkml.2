Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966319Ab2JZTzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 15:55:16 -0400
Received: from na3sys010aog112.obsmtp.com ([74.125.245.92]:40234 "HELO
	na3sys010aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S966294Ab2JZTzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 15:55:08 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Fri, 26 Oct 2012 12:55:00 -0700
Message-Id: <1351281300-27825-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------

Small batch of fixes for 3.7:
 - Fix crash in error path in cxgb4
 - Fix build error on 32 bits in mlx4
 - Fix SR-IOV bugs in mlx4

----------------------------------------------------------------
Dotan Barak (1):
      mlx4_core: Perform correct resource cleanup if mlx4_QUERY_ADAPTER() fails

Doug Ledford (1):
      IB/mlx4: Fix build error on platforms where UL is not 64 bits

Eli Cohen (1):
      IB/mlx4: Synchronize cleanup of MCGs in MCG paravirtualization

Jack Morgenstein (1):
      IB/mlx4: Fix QP1 P_Key processing in the Primary Physical Function (PPF)

Or Gerlitz (1):
      mlx4_core: Remove annoying debug messages from SR-IOV flow

Roland Dreier (1):
      Merge branches 'cxgb4' and 'mlx4' into for-next

Thadeu Lima de Souza Cascardo (1):
      RDMA/cxgb4: Don't free chunk that we have failed to allocate

 drivers/infiniband/hw/cxgb4/mem.c                  |    2 +-
 drivers/infiniband/hw/mlx4/alias_GUID.c            |    2 +-
 drivers/infiniband/hw/mlx4/mad.c                   |   85 +++++++++-----------
 drivers/infiniband/hw/mlx4/mcg.c                   |   18 +++--
 drivers/net/ethernet/mellanox/mlx4/eq.c            |    6 --
 drivers/net/ethernet/mellanox/mlx4/main.c          |    5 +-
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |    6 --
 7 files changed, 56 insertions(+), 68 deletions(-)
