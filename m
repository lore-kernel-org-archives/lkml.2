Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab2A1Dez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 22:34:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814Ab2A1Dey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 22:34:54 -0500
Date: Sat, 28 Jan 2012 11:34:50 +0800
From: Dave Young <dyoung@redhat.com>
To: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: [PATCH] add kernel parameter to disable module load
Message-ID: <20120128033450.GA2138@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes we need to test a kernel of same version with code or config
option changes.

We already have sysctl to disable module load, but add a kernel
parameter will be more convenient.
---
 Documentation/kernel-parameters.txt |    2 ++
 kernel/module.c                     |    7 +++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e229769..b5cd482 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1796,6 +1796,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	nomfgpt		[X86-32] Disable Multi-Function General Purpose
 			Timer usage (for AMD Geode machines).
 
+	nomodule	Disable module load
+
 	nopat		[X86] Disable PAT (page attribute table extension of
 			pagetables) support.
 
diff --git a/kernel/module.c b/kernel/module.c
index 178333c..72395f5 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3478,6 +3478,13 @@ void print_modules(void)
 	printk("\n");
 }
 
+static int __init module_load_disable(char *str)
+{
+	modules_disabled = 1;
+	return 1;
+}
+__setup("nomodule", module_load_disable);
+
 #ifdef CONFIG_MODVERSIONS
 /* Generate the signature for all relevant module structures here.
  * If these change, we don't want to try to parse the module. */
-- 
1.7.4.4

