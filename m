Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012Ab0G3SAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:00:11 -0400
Received: from kroah.org ([198.145.64.141]:59235 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932796Ab0G3R5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:57:46 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:50 2010
Message-Id: <20100730175150.806434200@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:53:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Reinette Chatre <reinette.chatre@intel.com>
Subject: [186/205] iwl3945: enable stuck queue detection on 3945
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Reinette Chatre <reinette.chatre@intel.com>

commit a6866ac93e6cb68091326e80b4fa4619a5957644 upstream.

We learn from
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=1834 and
https://bugzilla.redhat.com/show_bug.cgi?id=589777
that 3945 can also suffer from a stuck command queue. Enable stuck queue
detection for iwl3945 to enable recovery in this case.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-3945.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2792,6 +2792,7 @@ static struct iwl_lib_ops iwl3945_lib =
 	.isr = iwl_isr_legacy,
 	.config_ap = iwl3945_config_ap,
 	.add_bcast_station = iwl3945_add_bcast_station,
+	.recover_from_tx_stall = iwl_bg_monitor_recover,
 };
 
 static struct iwl_hcmd_utils_ops iwl3945_hcmd_utils = {


