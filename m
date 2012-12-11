Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab2LKOZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 09:25:00 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48766 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab2LKOY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 09:24:59 -0500
Date: Tue, 11 Dec 2012 06:24:53 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
Subject: [GIT PULL] percpu changes for v3.8
Message-ID: <20121211142453.GD7084@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Percpu changes for v3.8.  Nothing exciting here either.  Joonsoo's is
almost cosmetic.  Cyrill's patch fixes "percpu_alloc" early kernel
param handling so that the kernel doesn't crash when the parameter is
specified w/o any argument.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-next

Thanks.

----------------------------------------------------------------
Cyrill Gorcunov (1):
      mm, percpu: Make sure percpu_alloc early parameter has an argument

Joonsoo Kim (1):
      percpu: make pcpu_free_chunk() use pcpu_mem_free() instead of kfree()

 mm/percpu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index ddc5efb..8c8e08f 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -631,7 +631,7 @@ static void pcpu_free_chunk(struct pcpu_chunk *chunk)
 	if (!chunk)
 		return;
 	pcpu_mem_free(chunk->map, chunk->map_alloc * sizeof(chunk->map[0]));
-	kfree(chunk);
+	pcpu_mem_free(chunk, pcpu_chunk_struct_size);
 }
 
 /*
@@ -1380,6 +1380,9 @@ enum pcpu_fc pcpu_chosen_fc __initdata = PCPU_FC_AUTO;
 
 static int __init percpu_alloc_setup(char *str)
 {
+	if (!str)
+		return -EINVAL;
+
 	if (0)
 		/* nada */;
 #ifdef CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK
