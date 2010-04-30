Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256Ab0D3Stq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:49:46 -0400
Received: from smtp.nokia.com ([192.100.122.230]:61905 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932817Ab0D3RNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:13:13 -0400
From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 06/10] sysctl: don't use own implementation of hex_to_bin()
Date: Fri, 30 Apr 2010 12:34:05 +0300
Message-Id: <7cd86c01ad4a376fb8a48ffe307ce7c0510cecc0.1272617852.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <2eb558b7b0b20dfea0b61223db6146cb8fdbe52d.1272617852.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <d5c4e26cc74458dd77102c4274d3260149717328.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <1a326db89859eec030859e4905c515e0817bd2ea.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <d4a1df27bf2c83ee84c3d74bcff0f2768146eb7e.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <c1ca828fb308042aa32428b345abcb43ccb02c39.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <2eb558b7b0b20dfea0b61223db6146cb8fdbe52d.1272617852.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
X-OriginalArrivalTime: 30 Apr 2010 09:34:06.0773 (UTC) FILETIME=[4776AE50:01CAE848]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of own implementation of hex_to_bin().

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/sysctl_binary.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index 5903057..f4789ed 100644
--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -13,6 +13,7 @@
 #include <linux/file.h>
 #include <linux/ctype.h>
 #include <linux/netdevice.h>
+#include <linux/kernel.h>
 #include <linux/slab.h>
 
 #ifdef CONFIG_SYSCTL_SYSCALL
@@ -1125,11 +1126,6 @@ out:
 	return result;
 }
 
-static unsigned hex_value(int ch)
-{
-	return isdigit(ch) ? ch - '0' : ((ch | 0x20) - 'a') + 10;
-}
-
 static ssize_t bin_uuid(struct file *file,
 	void __user *oldval, size_t oldlen, void __user *newval, size_t newlen)
 {
@@ -1157,7 +1153,8 @@ static ssize_t bin_uuid(struct file *file,
 			if (!isxdigit(str[0]) || !isxdigit(str[1]))
 				goto out;
 
-			uuid[i] = (hex_value(str[0]) << 4) | hex_value(str[1]);
+			uuid[i] = (hex_to_bin(str[0]) << 4) |
+					hex_to_bin(str[1]);
 			str += 2;
 			if (*str == '-')
 				str++;
-- 
1.6.3.3

