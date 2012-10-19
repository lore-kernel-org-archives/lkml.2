Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965049Ab2JSDYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:24:05 -0400
Received: from mail.kernel.org ([198.145.19.201]:54461 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758040Ab2JSDRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 23:17:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Alex Lyashkov <umka@cloudlinux.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 14/37] module: taint kernel when lve module is loaded
Date: Thu, 18 Oct 2012 20:16:37 -0700
Message-Id: <20121019031305.151580551@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019031302.789593147@linuxfoundation.org>
References: <20121019031302.789593147@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2605,6 +2605,10 @@ static int check_module_license_and_vers
 	if (strcmp(mod->name, "driverloader") == 0)
 		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
 
+	/* lve claims to be GPL but upstream won't provide source */
+	if (strcmp(mod->name, "lve") == 0)
+		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
+
 #ifdef CONFIG_MODVERSIONS
 	if ((mod->num_syms && !mod->crcs)
 	    || (mod->num_gpl_syms && !mod->gpl_crcs)


