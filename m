Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190Ab0C3Xkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:40:49 -0400
Received: from kroah.org ([198.145.64.141]:46278 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932422Ab0C3XUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:20:37 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:13 2010
Message-Id: <20100330224812.801994837@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Adel Gadllah <adel.gadllah@gmail.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [081/156] iwlwifi: Silence tfds_in_queue message
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Adel Gadllah <adel.gadllah@gmail.com>

commit c8406ea8fa1adde8dc5400127281d497bbcdb84a upstream.

Commit a239a8b47cc0e5e6d7416a89f340beac06d5edaa introduced a
noisy message, that fills up the log very fast.

The error seems not to be fatal (the connection is stable and
performance is ok), so make it IWL_DEBUG_TX rather than IWL_ERR.

Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>
Acked-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -127,7 +127,7 @@ void iwl_free_tfds_in_queue(struct iwl_p
 	if (priv->stations[sta_id].tid[tid].tfds_in_queue >= freed)
 		priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
 	else {
-		IWL_ERR(priv, "free more than tfds_in_queue (%u:%d)\n",
+		IWL_DEBUG_TX(priv, "free more than tfds_in_queue (%u:%d)\n",
 			priv->stations[sta_id].tid[tid].tfds_in_queue,
 			freed);
 		priv->stations[sta_id].tid[tid].tfds_in_queue = 0;


