Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720Ab1LODXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 22:23:55 -0500
Received: from ozlabs.org ([203.10.76.45]:58308 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758694Ab1LODXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 22:23:43 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 7/15] printk: fix unnecessary module_param_name.
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
CC: Pawel Moll <pawel.moll@arm.com>
Date: Thu, 15 Dec 2011 13:40:13 +1030
Message-ID: <87r506sf6y.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You don't need module_param_name if the name is the same!

Cc: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/printk.c b/kernel/printk.c
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -532,7 +532,7 @@ static int __init ignore_loglevel_setup(
 }
 
 early_param("ignore_loglevel", ignore_loglevel_setup);
-module_param_named(ignore_loglevel, ignore_loglevel, bool, S_IRUGO | S_IWUSR);
+module_param(ignore_loglevel, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(ignore_loglevel, "ignore loglevel setting, to"
 	"print all kernel messages to the console.");
 
