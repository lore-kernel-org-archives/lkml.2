Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab2J1X3q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:29:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42257 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757085Ab2J1X2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:32 -0400
Message-Id: <20121028231544.706567998@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:01 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Alex Lyashkov <umka@cloudlinux.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 025/105] module: taint kernel when lve module is loaded
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


