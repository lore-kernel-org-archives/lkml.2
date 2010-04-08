Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab0DHIg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 04:36:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35977
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752567Ab0DHIg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 04:36:26 -0400
Date: Thu, 08 Apr 2010 01:36:28 -0700 (PDT)
Message-Id: <20100408.013628.171442882.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT] IDE
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get these IDE bug fixes:

1) DMA timeouts cause requests to get lost completely and never
   requeued.  Fix from Herbert Xu.  (Tejun has a different
   approach to this problem which makes PIO and DMA timeouts
   get handled more symmetrically, but I'll defer that to
   ide-next-2.6)

2) taskfile ops with CFQ scheduler bomb because the taskfile
   code allocates a request then changes it's direction (e.g.
   READ vs. WRITE) and this makes CFQ explode.  Fix by allocating
   the correct request type from the beginning.  From Mikulas Patocka.

Thanks!

The following changes since commit 48de8cb7847d040c8892701c1ff3c55eff1f46b4:
  Linus Torvalds (1):
        Merge branch 'perf-fixes-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/ide-2.6.git master

Herbert Xu (2):
      ide: Requeue request after DMA timeout
      ide: Must hold queue lock when requeueing

Mikulas Patocka (1):
      ide: Fix IDE taskfile with cfq scheduler

 drivers/ide/ide-atapi.c    |    2 +-
 drivers/ide/ide-dma.c      |    1 +
 drivers/ide/ide-io.c       |    2 +-
 drivers/ide/ide-taskfile.c |    6 ++----
 include/linux/ide.h        |    1 +
 5 files changed, 6 insertions(+), 6 deletions(-)
