Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab2KZRCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:02:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47178 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365Ab2KZRCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:02:07 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Alex Lyashkov <umka@cloudlinux.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 037/270] module: taint kernel when lve module is loaded
Date: Mon, 26 Nov 2012 14:55:27 -0200
Message-Id: <1353949160-26803-38-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Garrett <mjg59@srcf.ucam.org>

commit c99af3752bb52ba3aece5315279a57a477edfaf1 upstream.

Cloudlinux have a product called lve that includes a kernel module. This
was previously GPLed but is now under a proprietary license, but the
module continues to declare MODULE_LICENSE("GPL") and makes use of some
EXPORT_SYMBOL_GPL symbols. Forcibly taint it in order to avoid this.

Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alex Lyashkov <umka@cloudlinux.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/module.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/module.c b/kernel/module.c
index 4edbd9c..9ad9ee9 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2730,6 +2730,10 @@ static int check_module_license_and_versions(struct module *mod)
 	if (strcmp(mod->name, "driverloader") == 0)
 		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
 
+	/* lve claims to be GPL but upstream won't provide source */
+	if (strcmp(mod->name, "lve") == 0)
+		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
+
 #ifdef CONFIG_MODVERSIONS
 	if ((mod->num_syms && !mod->crcs)
 	    || (mod->num_gpl_syms && !mod->gpl_crcs)
-- 
1.7.9.5

