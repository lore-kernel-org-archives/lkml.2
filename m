Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab1CRMyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 08:54:47 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37288 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486Ab1CRMyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 08:54:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=AGRt0CAUVq3YNWlfd/RhOVBWUfw2SncI0V8C3KLaToHMcJl18b3kIPqEznehlfp3N/
         T9ijiV6tYBE1NV23YFI5NSiGpGmEHvpnCnIG8BX6N2iYJKcYux+z9BF90QX6eqejS9M3
         y/lugXGASTZPWRq8aXNEB05BjV6ZoKF6e1mL0=
From: Namhyung Kim <namhyung@gmail.com>
To: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 2/3] memcg: fix off-by-one when calculating swap cgroup map length
Date: Fri, 18 Mar 2011 21:54:14 +0900
Message-Id: <1300452855-10194-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1300452855-10194-1-git-send-email-namhyung@gmail.com>
References: <1300452855-10194-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It allocated one more page than necessary if @max_pages was
a multiple of SC_PER_PAGE.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/page_cgroup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 2d1a0fa01d7b..29951abc852e 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -446,7 +446,7 @@ int swap_cgroup_swapon(int type, unsigned long max_pages)
 	if (!do_swap_account)
 		return 0;
 
-	length = ((max_pages/SC_PER_PAGE) + 1);
+	length = DIV_ROUND_UP(max_pages, SC_PER_PAGE);
 	array_size = length * sizeof(void *);
 
 	array = vmalloc(array_size);
-- 
1.7.4

