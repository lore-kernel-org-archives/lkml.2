Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab2ACXFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 18:05:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39443 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016Ab2ACWfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:35:48 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:33 2012
Message-Id: <20120103223033.881781387@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:29:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [30/67] iwlwifi: allow to switch to HT40 if not associated
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

commit 78feb35b8161acd95c33a703ed6ab6f554d29387 upstream.

My previous patch
34a5b4b6af104cf18eb50748509528b9bdbc4036 iwlwifi: do not re-configure
HT40 after associated

Fix the case of HT40 after association on specified AP, but it break the
association for some APs and cause not able to establish connection.
We need to address HT40 before and after addociation.

Reported-by: Andrej Gelenberg <andrej.gelenberg@udo.edu>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Tested-by: Andrej Gelenberg <andrej.gelenberg@udo.edu>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -490,8 +490,8 @@ int iwlagn_mac_config(struct ieee80211_h
 			if (ctx->ht.enabled) {
 				/* if HT40 is used, it should not change
 				 * after associated except channel switch */
-				if (iwl_is_associated_ctx(ctx) &&
-				     !ctx->ht.is_40mhz)
+				if (!ctx->ht.is_40mhz ||
+						!iwl_is_associated_ctx(ctx))
 					iwlagn_config_ht40(conf, ctx);
 			} else
 				ctx->ht.is_40mhz = false;


