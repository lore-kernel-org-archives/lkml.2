Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab2ISFpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 01:45:44 -0400
Received: from ozlabs.org ([203.10.76.45]:48356 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab2ISFpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 01:45:00 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Greg KH" <gregkh@linuxfoundation.org>,
        Alex Lyashkov <umka@cloudlinux.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Subject: lve module taint?
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 19 Sep 2012 11:32:40 +0930
Message-ID: <87sjaepy67.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

        I still have this patch sitting in my queue for next merge
window; I missed the previous one.  Is it still current?

Thanks,
Rusty.

From:	Matthew Garrett <mjg59@srcf.ucam.org>
Subject: module: taint kernel when lve module is loaded
Date: Fri, 22 Jun 2012 13:49:31 -0400

Cloudlinux have a product called lve that includes a kernel module. This
was previously GPLed but is now under a proprietary license, but the
module continues to declare MODULE_LICENSE("GPL") and makes use of some
EXPORT_SYMBOL_GPL symbols. Forcibly taint it in order to avoid this.

Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alex Lyashkov <umka@cloudlinux.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: stable@kernel.org
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
