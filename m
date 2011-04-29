Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933680Ab1D2TAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:00:49 -0400
Received: from kroah.org ([198.145.64.141]:35133 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933641Ab1D2S6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:52 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:57 2011
Message-Id: <20110429185657.635894807@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:56:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [52/55] iwl3945: do not deprecate software scan
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 3bda50e3eaf58a4b9c4ce34204e5faa15c8b1b97 upstream.

Software scanning can be used for workaround some performance problems,
so do not deprecate it.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3995,8 +3995,7 @@ static int iwl3945_pci_probe(struct pci_
 	 * "the hard way", rather than using device's scan.
 	 */
 	if (iwl3945_mod_params.disable_hw_scan) {
-		dev_printk(KERN_DEBUG, &(pdev->dev),
-			"sw scan support is deprecated\n");
+		IWL_DEBUG_INFO(priv, "Disabling hw_scan\n");
 		iwl3945_hw_ops.hw_scan = NULL;
 	}
 
@@ -4318,8 +4317,7 @@ MODULE_PARM_DESC(debug, "debug output ma
 #endif
 module_param_named(disable_hw_scan, iwl3945_mod_params.disable_hw_scan,
 		   int, S_IRUGO);
-MODULE_PARM_DESC(disable_hw_scan,
-		 "disable hardware scanning (default 0) (deprecated)");
+MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 0)");
 module_param_named(fw_restart3945, iwl3945_mod_params.restart_fw, int, S_IRUGO);
 MODULE_PARM_DESC(fw_restart3945, "restart firmware in case of error");
 


