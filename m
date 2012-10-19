Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab2JSDQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:16:22 -0400
Received: from mail.kernel.org ([198.145.19.201]:51480 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757344Ab2JSCrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:47:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Alex Lyashkov <umka@cloudlinux.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 26/62] module: taint kernel when lve module is loaded
Date: Thu, 18 Oct 2012 19:44:54 -0700
Message-Id: <20121019024300.183823614@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024255.944999470@linuxfoundation.org>
References: <20121019024255.944999470@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/module.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2729,6 +2729,10 @@ static int check_module_license_and_vers
 	if (strcmp(mod->name, "driverloader") == 0)
 		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
 
+	/* lve claims to be GPL but upstream won't provide source */
+	if (strcmp(mod->name, "lve") == 0)
+		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
+
 #ifdef CONFIG_MODVERSIONS
 	if ((mod->num_syms && !mod->crcs)
 	    || (mod->num_gpl_syms && !mod->gpl_crcs)


