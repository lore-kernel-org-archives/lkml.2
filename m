Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828Ab2GBU0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 16:26:39 -0400
Received: from relay3.sgi.com ([192.48.152.1]:33434 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932104Ab2GBU0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 16:26:38 -0400
Date: Mon, 2 Jul 2012 15:26:36 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Christoph Lameter <cl@linux.com>, Nick Piggin <npiggin@gmail.com>,
        Hugh Dickins <hughd@google.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH 0/2 v4][rfc] tmpfs not interleaving properly
Message-ID: <20120702202635.GA20284@gulag1.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
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

v2: passed preferred node via addr
v3: using current->cpuset_mem_spread_rotor instead of random_node
v4: Switching the rotor and attempting to provide an interleave function
Also splitting the patch into two sections.

Cc: Christoph Lameter <cl@linux.com>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Nathan T Zimmer <nzimmer@sgi.com>
---

 include/linux/mm.h       |    6 ++++++
 include/linux/shmem_fs.h |    2 ++
 mm/mempolicy.c           |    4 ++++
 mm/shmem.c               |   33 ++++++++++++++++++++++++++++++---
 4 files changed, 42 insertions(+), 3 deletions(-)

