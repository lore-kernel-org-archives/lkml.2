Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab2ADMEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 07:04:42 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33381 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab2ADMEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 07:04:39 -0500
From: Fabio Estevam <festevam@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux@arm.linux.org.uk,
        Fabio Estevam <festevam@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] include: crash_dump.h: Add elf.h header
Date: Wed,  4 Jan 2012 10:04:26 -0200
Message-Id: <1325678666-13089-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building an ARM target we get the following warnings:

CC      arch/arm/kernel/setup.o
In file included from arch/arm/kernel/setup.c:39:
arch/arm/include/asm/elf.h:102:1: warning: "vmcore_elf64_check_arch" redefined
In file included from arch/arm/kernel/setup.c:24:
include/linux/crash_dump.h:30:1: warning: this is the location of the previous definition

Quoting Russell King:

"linux/crash_dump.h makes no attempt to include asm/elf.h, but it depends
on stuff in asm/elf.h to determine how stuff inside this file is defined
at parse time.

So, if asm/elf.h is included after linux/crash_dump.h or not at all, you
get a different result from the situation where asm/elf.h is included
before."

So add elf.h header to crash_dump.h to avoid this problem.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
The original discussion about this can be found at:
http://www.spinics.net/lists/arm-kernel/msg154113.html

 include/linux/crash_dump.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
index 5c4abce..b936763 100644
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -5,6 +5,7 @@
 #include <linux/kexec.h>
 #include <linux/device.h>
 #include <linux/proc_fs.h>
+#include <linux/elf.h>
 
 #define ELFCORE_ADDR_MAX	(-1ULL)
 #define ELFCORE_ADDR_ERR	(-2ULL)
-- 
1.7.1

