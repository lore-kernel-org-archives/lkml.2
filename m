Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab1JXWPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 18:15:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab1JXWPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 18:15:42 -0400
Date: Mon, 24 Oct 2011 18:15:32 -0400
From: Dave Jones <davej@redhat.com>
To: Richard Weinberger <richard@nod.at>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Fix kmalloc argument order in um/vdso/vma.c
Message-ID: <20111024221532.GA22671@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Richard Weinberger <richard@nod.at>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmalloc size is 1st arg, not second.

Signed-off-by: Dave Jones <davej@redhat.com>

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
 
