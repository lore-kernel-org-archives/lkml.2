Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab2ABN65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 08:58:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44745 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab2ABN6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 08:58:55 -0500
Date: Mon, 2 Jan 2012 14:58:51 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] module: log OOT_MODULE tainting
Message-ID: <alpine.LNX.2.00.1201021456120.24984@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow what we do with other taints and output a message into kernel ring 
buffer once tainting a kernel because out-of-tree module is being loaded.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/kernel/module.c b/kernel/module.c
index b02d633..3f52b3e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2478,8 +2478,11 @@ static int check_modinfo(struct module *mod, struct load_info *info)
 		return -ENOEXEC;
 	}
 
-	if (!get_modinfo(info, "intree"))
+	if (!get_modinfo(info, "intree")) {
 		add_taint_module(mod, TAINT_OOT_MODULE);
+		printk(KERN_WARNING "%s: out of tree module taints kernel\n",
+				mod->name);
+	}
 
 	if (get_modinfo(info, "staging")) {
 		add_taint_module(mod, TAINT_CRAP);
