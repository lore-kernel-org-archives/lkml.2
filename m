Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab0JQQlr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 12:41:47 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35102 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411Ab0JQQlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 12:41:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mZTFiqmuuyvLPvwp45xWfpZOY+J0cnQ8VNYClKKyPk1AyI/onxmuI19zuDEEF9QkO5
         3ziTUYMGOnrgLZcdWWAEUPc2GOnusl/IyB60nPDsaBk68sVd6Kea3nniIRFdhYhGjact
         xZc8JK/82uGCN0eywJ80MCcYivvEDom68/tkI=
From: Namhyung Kim <namhyung@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] MIPS: Fix build failure on asm/fcntl.h
Date: Mon, 18 Oct 2010 01:41:39 +0900
Message-Id: <1287333699-1254-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  CC      security/integrity/ima/ima_fs.o
In file included from linux/include/linux/fcntl.h:4:0,
                 from linux/security/integrity/ima/ima_fs.c:18:
linux/arch/mips/include/asm/fcntl.h:63:2: error: expected specifier-qualifier-list before 'off_t'
make[3]: *** [security/integrity/ima/ima_fs.o] Error 1
make[2]: *** [security/integrity/ima/ima_fs.o] Error 2
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 arch/mips/include/asm/fcntl.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/mips/include/asm/fcntl.h b/arch/mips/include/asm/fcntl.h
index e482fe9..75edded 100644
--- a/arch/mips/include/asm/fcntl.h
+++ b/arch/mips/include/asm/fcntl.h
@@ -56,6 +56,7 @@
  */
 
 #ifdef CONFIG_32BIT
+#include <linux/types.h>
 
 struct flock {
 	short	l_type;
-- 
1.7.0.4

