Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965255Ab1KJDkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:40:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44137 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965240Ab1KJDkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:40:13 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:52 2011
Message-Id: <20111109213152.583557479@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:32:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stanislaw Gruszka <sgruszka@redhat.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [104/264] iwlagn: fix priv->cfg->ht_params NULL pointer dereference
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 107ef97a170dec95893f34614edd92eb8cb9b5d0 upstream.

This fix regression introduced by commit:

commit 15b3f3b006b42a678523cad989bfd60b76bf4403
Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date:   Fri Jun 3 07:54:13 2011 -0700

    iwlagn: set smps mode after assoc for 1000 device

Also remove unneeded brackets on the way.

Address:
https://bugzilla.redhat.com/show_bug.cgi?id=744155

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -295,8 +295,8 @@ static int iwlagn_rxon_connect(struct iw
 		return ret;
 	}
 
-	if ((ctx->vif && ctx->vif->type == NL80211_IFTYPE_STATION) &&
-	    priv->cfg->ht_params->smps_mode)
+	if (ctx->vif && ctx->vif->type == NL80211_IFTYPE_STATION &&
+	    priv->cfg->ht_params && priv->cfg->ht_params->smps_mode)
 		ieee80211_request_smps(ctx->vif,
 				       priv->cfg->ht_params->smps_mode);
 


