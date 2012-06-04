Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab2FDEbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 00:31:13 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:32955 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab2FDEbL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 00:31:11 -0400
From: <gerg@snapgear.com>
To: <linux-kernel@vger.kernel.org>
CC: <viro@zeniv.linux.org.uk>, Greg Ungerer <gerg@uclinux.org>
Subject: [PATCH] nommu: fix compilation of nommu.c
Date: Mon, 4 Jun 2012 14:29:59 +1000
Message-ID: <1338784199-19286-1-git-send-email-gerg@snapgear.com>
X-Mailer: git-send-email 1.5.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Ungerer <gerg@uclinux.org>

Compiling 3.5-rc1 for nommu targets gives:

  CC      mm/nommu.o
mm/nommu.c: In function ‘sys_mmap_pgoff’:
mm/nommu.c:1489:2: error: ‘ret’ undeclared (first use in this function)
mm/nommu.c:1489:2: note: each undeclared identifier is reported only once for each function it appears in

It is trivially fixed by replacing 'ret' with the local variable that is
already defined for the return value 'retval'.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---
 mm/nommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
-- 
1.7.0.4

