Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab2FDOJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 10:09:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832Ab2FDOJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 10:09:30 -0400
Subject: build failure in mm/nommu.c
From: Mark Salter <msalter@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 04 Jun 2012 10:09:26 -0400
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1338818967.12086.30.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit eb36c587: new helper: vm_mmap_pgoff()

is causing a build failure:

.../linux/mm/nommu.c: In function 'sys_mmap_pgoff':
.../linux/mm/nommu.c:1489:2: error: 'ret' undeclared (first use in this function)
.../linux/mm/nommu.c:1489:2: note: each undeclared identifier is reported only once for each function it appears in

It looks like it just needs:

diff --git a/mm/nommu.c b/mm/nommu.c
index c4acfbc..d4b0c10 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1486,7 +1486,7 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned long, addr, unsigned long, len,
 
 	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
 
-	ret = vm_mmap_pgoff(file, addr, len, prot, flags, pgoff);
+	retval = vm_mmap_pgoff(file, addr, len, prot, flags, pgoff);
 
 	if (file)
 		fput(file);


