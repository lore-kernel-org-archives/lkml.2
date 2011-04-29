Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662Ab1D2TAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:00:30 -0400
Received: from kroah.org ([198.145.64.141]:35139 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933647Ab1D2S6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:53 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:57 2011
Message-Id: <20110429185657.739612508@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:56:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [53/55] iwl3945: disable hw scan by default
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 0263aa45293838b514b8af674a03faf040991a90 upstream.

After new NetworkManager 0.8.996 changes, hardware scanning is causing
microcode errors as reported here:
https://bugzilla.redhat.com/show_bug.cgi?id=683571
and sometimes kernel crashes:
https://bugzilla.redhat.com/show_bug.cgi?id=688252

Also with hw scan there are very bad performance on some systems
as reported here:
https://bugzilla.redhat.com/show_bug.cgi?id=671366

Since Intel no longer supports 3945, there is no chance to get proper
firmware fixes, we need workaround problems by disable hardware scanning
by default.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -94,6 +94,7 @@ MODULE_LICENSE("GPL");
 struct iwl_mod_params iwl3945_mod_params = {
 	.sw_crypto = 1,
 	.restart_fw = 1,
+	.disable_hw_scan = 1,
 	/* the rest are 0 by default */
 };
 
@@ -4317,7 +4318,7 @@ MODULE_PARM_DESC(debug, "debug output ma
 #endif
 module_param_named(disable_hw_scan, iwl3945_mod_params.disable_hw_scan,
 		   int, S_IRUGO);
-MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 0)");
+MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 1)");
 module_param_named(fw_restart3945, iwl3945_mod_params.restart_fw, int, S_IRUGO);
 MODULE_PARM_DESC(fw_restart3945, "restart firmware in case of error");
 


