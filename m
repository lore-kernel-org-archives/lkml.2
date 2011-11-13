Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392Ab1KMMA7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 07:00:59 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:40174 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab1KMMA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 07:00:58 -0500
Subject: [PATCH] [TRIVIAL] s390: drop "select HAVE_GET_USER_PAGES_FAST"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Nov 2011 13:00:56 +0100
Message-ID: <1321185656.20271.50.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no Kconfig symbol named HAVE_GET_USER_PAGES_FAST. The select
statement for that symbol is a nop. Drop it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Tested with "yes "" | make ARCH=s390 config" before and after
applying this patch. Identical .config files were generated, as was
expected.

1) This select statement was, I must assume, deliberately added in
commit 80217147a3 ("[S390] lockless get_user_pages_fast()"). Perhaps
there was some confusion about the amount of magic actually involved in
the kbuild system.

 arch/s390/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index a9fbd43..7014cfc 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -87,7 +87,6 @@ config S390
 	select HAVE_KERNEL_LZMA
 	select HAVE_KERNEL_LZO
 	select HAVE_KERNEL_XZ
-	select HAVE_GET_USER_PAGES_FAST
 	select HAVE_ARCH_MUTEX_CPU_RELAX
 	select HAVE_ARCH_JUMP_LABEL if !MARCH_G5
 	select HAVE_RCU_TABLE_FREE if SMP
-- 
1.7.4.4



