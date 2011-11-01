Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab1KALJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 07:09:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37353 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625Ab1KALJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 07:09:09 -0400
Date: Tue, 1 Nov 2011 12:09:03 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] um: vDSO: fix vdsop allocation
Message-ID: <alpine.LNX.2.00.1111011207190.348@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kmalloc() call in init_vdso() has reverse order of arguments.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 arch/um/sys-x86_64/vdso/vma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/sys-x86_64/vdso/vma.c b/arch/um/sys-x86_64/vdso/vma.c
index 9495c8d..91f4ec9 100644
--- a/arch/um/sys-x86_64/vdso/vma.c
+++ b/arch/um/sys-x86_64/vdso/vma.c
@@ -28,7 +28,7 @@ static int __init init_vdso(void)
 
 	um_vdso_addr = task_size - PAGE_SIZE;
 
-	vdsop = kmalloc(GFP_KERNEL, sizeof(struct page *));
+	vdsop = kmalloc(sizeof(struct page *), GFP_KERNEL);
 	if (!vdsop)
 		goto oom;
 
-- 
Jiri Kosina
SUSE Labs

