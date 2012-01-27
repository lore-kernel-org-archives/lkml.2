Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab2A0CpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 21:45:10 -0500
Received: from mail.windriver.com ([147.11.1.11]:53770 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab2A0CpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 21:45:02 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org, gregkh@suse.de,
        rmk+kernel@arm.linux.org.uk
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 3/7] lib: fix implicit users of kernel.h for TAINT_WARN
Date: Thu, 26 Jan 2012 21:44:28 -0500
Message-Id: <1327632272-12928-4-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.7.2
In-Reply-To: <1327632272-12928-1-git-send-email-paul.gortmaker@windriver.com>
References: <1327632272-12928-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A pending header cleanup will cause this to show up as:

lib/average.c:38: error: 'TAINT_WARN' undeclared (first use in this function)
lib/list_debug.c:24: error: 'TAINT_WARN' undeclared (first use in this function)

and TAINT_WARN comes from include/linux/kernel.h file.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 lib/average.c    |    1 +
 lib/list_debug.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/lib/average.c b/lib/average.c
index 5576c28..57c38c6 100644
--- a/lib/average.c
+++ b/lib/average.c
@@ -7,6 +7,7 @@
 
 #include <linux/module.h>
 #include <linux/average.h>
+#include <linux/kernel.h>
 #include <linux/bug.h>
 #include <linux/log2.h>
 
diff --git a/lib/list_debug.c b/lib/list_debug.c
index b8029a5..7204e61 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -8,6 +8,7 @@
 
 #include <linux/module.h>
 #include <linux/list.h>
+#include <linux/kernel.h>
 
 /*
  * Insert a new entry between two known consecutive entries.
-- 
1.7.7.2

