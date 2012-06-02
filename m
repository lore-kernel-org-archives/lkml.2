Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965858Ab2FBUgt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 16:36:49 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:42687 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965160Ab2FBUf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 16:35:57 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Tony Breeds <tony@bakeyournoodle.com>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 4/5] h8300/uaccess: Remove assignment to __gu_val in unhandled case of get_user()
Date: Sat,  2 Jun 2012 22:35:38 +0200
Message-Id: <1338669339-23214-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1338669339-23214-1-git-send-email-geert@linux-m68k.org>
References: <1338669339-23214-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__gu_val is const if the passed ptr is const, giving:

include/linux/pagemap.h: In function 'fault_in_pages_readable':
include/linux/pagemap.h:442:2: error: assignment of read-only variable '__gu_val'
include/linux/pagemap.h:448:4: error: assignment of read-only variable '__gu_val'
include/linux/pagemap.h: In function 'fault_in_multipages_readable':
include/linux/pagemap.h:499:3: error: assignment of read-only variable '__gu_val'
include/linux/pagemap.h:508:3: error: assignment of read-only variable '__gu_val'
make[4]: *** [init/main.o] Error 1

As we don't care about the actual value of __gu_val in the unhandled
case (it will cause a link error anyway), just remove the assignment.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/h8300/include/asm/uaccess.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/h8300/include/asm/uaccess.h b/arch/h8300/include/asm/uaccess.h
index 356068c..534394f 100644
--- a/arch/h8300/include/asm/uaccess.h
+++ b/arch/h8300/include/asm/uaccess.h
@@ -100,7 +100,6 @@ extern int __put_user_bad(void);
 	break;							\
     default:							\
 	__gu_err = __get_user_bad();				\
-	__gu_val = 0;						\
 	break;							\
     }								\
     (x) = __gu_val;						\
-- 
1.7.0.4

