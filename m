Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759448Ab2CTKRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 06:17:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:29844 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754643Ab2CTKQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 06:16:23 -0400
X-IronPort-AV: E=Sophos;i="4.73,617,1325433600"; 
   d="scan'208";a="4579990"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [RFC PATCH 0/6] add kmalloc_align()
Date: Tue, 20 Mar 2012 18:21:18 +0800
Message-Id: <1332238884-6237-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-20 18:14:11,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-20 18:14:12,
	Serialize complete at 2012-03-20 18:14:12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add add kmalloc_align() for alignment requirement.
Almost no behavior changed nor overhead added.

Lai Jiangshan (6):
  kenrel.h: add ALIGN_OF_LAST_BIT()
  slub: add kmalloc_align()
  slab: add kmalloc_align()
  don't couple the header size with the alignment
  slob: add kmalloc_align()
  workqueue: use kmalloc_align() instead of hacking

 include/linux/kernel.h   |    2 ++
 include/linux/slab_def.h |    6 ++++++
 include/linux/slob_def.h |   14 +++++++++++++-
 include/linux/slub_def.h |    6 ++++++
 init/Kconfig             |    1 -
 kernel/workqueue.c       |   23 ++++++++-------------------------------------
 mm/slab.c                |    8 ++++----
 mm/slob.c                |   38 +++++++++++++++++++++-----------------
 mm/slub.c                |    2 +-
 9 files changed, 58 insertions(+), 41 deletions(-)

-- 
1.7.4.4

