Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759748Ab0EELWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 07:22:32 -0400
Received: from smtp.nokia.com ([192.100.122.230]:18447 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154Ab0EELWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 07:22:31 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: balbir@linux.vnet.ibm.com, nishimura@mxp.nes.nec.co.jp,
       kamezawa.hiroyu@jp.fujitsu.com
Cc: akpm@linux-foundation.org, kirill@shutemov.name, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mm: memcontrol - uninitialised return value
Date: Wed,  5 May 2010 14:21:49 +0300
Message-Id: <1273058509-16625-2-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1273058509-16625-1-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1273058509-16625-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-OriginalArrivalTime: 05 May 2010 11:21:34.0793 (UTC) FILETIME=[1ED93390:01CAEC45]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Phil Carmody <ext-phil.2.carmody@nokia.com>

Only an out of memory error will cause ret to be set.

Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 90e32b2..09af773 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3464,7 +3464,7 @@ static int mem_cgroup_unregister_event(struct cgroup *cgrp, struct cftype *cft,
 	int type = MEMFILE_TYPE(cft->private);
 	u64 usage;
 	int size = 0;
-	int i, j, ret;
+	int i, j, ret = 0;
 
 	mutex_lock(&memcg->thresholds_lock);
 	if (type == _MEM)
-- 
1.6.0.4

