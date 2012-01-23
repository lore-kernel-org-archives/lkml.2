Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab2AWXsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:48:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42486 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755725Ab2AWXsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:48:17 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 15:40:26 2012
Message-Id: <20120123234026.239178531@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 15:39:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Philip Rakity <prakity@marvell.com>,
        Aaron Lu <aaron.lu@amd.com>, Adrian Hunter <adrian.hunter@intel.com>,
        Chris Ball <cjb@laptop.org>
Subject: [39/90] mmc: sdhci: Fix tuning timer incorrect setting when suspending host
In-Reply-To: <20120123234211.GA19504@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Lu <aaron.lu@amd.com>

commit c6ced0db08010ed75df221a2946c5228454b38d5 upstream.

When suspending host, the tuning timer shoule be deactivated.
And the HOST_NEEDS_TUNING flag should be set after tuning timer is
deactivated.

Signed-off-by: Philip Rakity <prakity@marvell.com>
Signed-off-by: Aaron Lu <aaron.lu@amd.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/host/sdhci.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2227,9 +2227,8 @@ int sdhci_suspend_host(struct sdhci_host
 	/* Disable tuning since we are suspending */
 	if (host->version >= SDHCI_SPEC_300 && host->tuning_count &&
 	    host->tuning_mode == SDHCI_TUNING_MODE_1) {
+		del_timer_sync(&host->tuning_timer);
 		host->flags &= ~SDHCI_NEEDS_RETUNING;
-		mod_timer(&host->tuning_timer, jiffies +
-			host->tuning_count * HZ);
 	}
 
 	ret = mmc_suspend_host(host->mmc);


