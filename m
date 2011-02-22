Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab1BVWWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:22:09 -0500
Received: from kroah.org ([198.145.64.141]:46790 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773Ab1BVWWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:22:02 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:41 2011
Message-Id: <20110222221841.208902876@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [42/70] iwl3945: remove plcp check
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit c91d01556f52255a31575be0cb1981c92a2a5028 upstream.

Patch fixes:
https://bugzilla.redhat.com/show_bug.cgi?id=654599

Many users report very low speed problem on 3945 devices,
this patch fixes problem, but only for some of them.

For unknown reason, sometimes after hw scanning, device is not able
to receive frames at high rate. Since plcp health check may request
hw scan to "reset radio", performance problem start to be observable
after update kernel to .35, where plcp check was introduced.

Bug reporter confirmed that removing plcp check fixed problem for him.

Reported-and-tested-by: SilvioTO <silviotoya@yahoo.it>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-3945.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2727,7 +2727,6 @@ static struct iwl_lib_ops iwl3945_lib =
 	.config_ap = iwl3945_config_ap,
 	.manage_ibss_station = iwl3945_manage_ibss_station,
 	.recover_from_tx_stall = iwl_bg_monitor_recover,
-	.check_plcp_health = iwl3945_good_plcp_health,
 
 	.debugfs_ops = {
 		.rx_stats_read = iwl3945_ucode_rx_stats_read,


