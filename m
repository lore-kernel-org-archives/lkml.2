Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab2GCToi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 15:44:38 -0400
Received: from relay2.sgi.com ([192.48.179.30]:32838 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753188Ab2GCTog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 15:44:36 -0400
From: Nathan Zimmer <nzimmer@sgi.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Nathan Zimmer <nzimmer@sgi.com>
Subject: [PATCH 0/2 v5][rfc] tmpfs not interleaving properly 
Date: Tue,  3 Jul 2012 14:44:33 -0500
Message-Id: <1341344675-17534-1-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When tmpfs has the memory policy interleaved it always starts allocating at each
file at node 0.  When there are many small files the lower nodes fill up
disproportionately.
This patch spreads out node usage by starting files at nodes other then 0.
The tmpfs superblock grants an offset for each inode as they are created. Each
then uses that offset to proved a prefered first node for its interleave in
the shmem_interleave.

v2: passed preferred node via addr.
v3: using current->cpuset_mem_spread_rotor instead of random_node.
v4: Switching the rotor and attempting to provide an interleave function.
Also splitting the patch into two sections.
v5: Corrected unsigned to long.

Nathan Zimmer (2):
  shmem: provide vm_ops when also providing a mem policy
  tmpfs: interleave the starting node of /dev/shmem

 include/linux/mm.h       |    7 +++++++
 include/linux/shmem_fs.h |    3 +++
 mm/mempolicy.c           |    4 ++++
 mm/shmem.c               |   35 ++++++++++++++++++++++++++++++++---
 4 files changed, 46 insertions(+), 3 deletions(-)

