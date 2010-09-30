Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab0I3Dva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 23:51:30 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56474 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab0I3Du4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 23:50:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NElvE9doKD+1CIZNOFYl4XCwXpVNbE6RGvY9NSEGOwZCfHtCnoDtES8jEfw8Kc81Bl
         8k7VVKLmHCJ9J+qZA1gry/2GZXeuj69TQNzmyEDb9sydj03SJWZtzv3dp7LhIrKAYO3e
         K5geut2seV4/koOezq9schudb7C6Dz23tVyXI=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/12] vmalloc: annotate lock context change on s_start/stop()
Date: Thu, 30 Sep 2010 12:50:19 +0900
Message-Id: <1285818621-29890-11-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285818621-29890-1-git-send-email-namhyung@gmail.com>
References: <1285818621-29890-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s_start() and s_stop() grab/release vmlist_lock but were missing proper
annotations. Add them.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 mm/vmalloc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 7ce8ca5..0be8470 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2339,6 +2339,7 @@ void pcpu_free_vm_areas(struct vm_struct **vms, int nr_vms)
 
 #ifdef CONFIG_PROC_FS
 static void *s_start(struct seq_file *m, loff_t *pos)
+	__acquires(&vmlist_lock)
 {
 	loff_t n = *pos;
 	struct vm_struct *v;
@@ -2365,6 +2366,7 @@ static void *s_next(struct seq_file *m, void *p, loff_t *pos)
 }
 
 static void s_stop(struct seq_file *m, void *p)
+	__releases(&vmlist_lock)
 {
 	read_unlock(&vmlist_lock);
 }
-- 
1.7.2.2

