Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab1HIDNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 23:13:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:11633 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747Ab1HIDNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 23:13:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,341,1309762800"; 
   d="scan'208";a="36523938"
Subject: [PATCH ] printk: add module parameter ignore_loglevel to control
 ignore_loglevel
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Organization: UMG
Date: Tue, 09 Aug 2011 11:12:44 +0800
Message-ID: <1312859564.1743.13.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are enabling some power features on medfield. To test suspend-2-RAM
conveniently, we need turn on/off ignore_loglevel frequently without rebooting.

Below patch adds a module parameter, so users could change it by:
/sys/module/printk/parameters/ignore_loglevel

Signed-off-by: Yanmin Zhang <yanmin.zhang@intel.com>

---
 kernel/printk.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index ce00f1b..12d4437 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -530,6 +530,7 @@ static int __init ignore_loglevel_setup(char *str)
 }
 
 early_param("ignore_loglevel", ignore_loglevel_setup);
+module_param_named(ignore_loglevel, ignore_loglevel, bool, S_IRUGO | S_IWUSR);
 
 /*
  * Write out chars from start to end - 1 inclusive
-- 
1.7.1



