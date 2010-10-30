Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab0J3VqG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:46:06 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11946 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab0J3VqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:46:04 -0400
Date: Sat, 30 Oct 2010 23:35:46 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: linux-mm@kvack.org, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org
Subject: [PATCH] cgroup: Avoid a memset by using vzalloc
Message-ID: <alpine.LNX.2.00.1010302333130.1572@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We can avoid doing a memset in swap_cgroup_swapon() by using vzalloc().


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
compile tested only.
 page_cgroup.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 5bffada..34970c7 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -450,11 +450,10 @@ int swap_cgroup_swapon(int type, unsigned long max_pages)
 	length = ((max_pages/SC_PER_PAGE) + 1);
 	array_size = length * sizeof(void *);
 
-	array = vmalloc(array_size);
+	array = vzalloc(array_size);
 	if (!array)
 		goto nomem;
 
-	memset(array, 0, array_size);
 	ctrl = &swap_cgroup_ctrl[type];
 	mutex_lock(&swap_cgroup_mutex);
 	ctrl->length = length;

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

