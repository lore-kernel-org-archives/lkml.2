Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab1I1X0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:26:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53787 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932220Ab1I1Wk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:40:27 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:28 2011
Message-Id: <20110928220128.284328296@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 14:59:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [029/244] ath9k: Fix PS wrappers in ath9k_set_coverage_class
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

commit 8b2a3827bb12430d932cd479b22d906baf08c212 upstream.

this callback is called during suspend/resume and also via iw command.
it configures parameters like sifs, slottime, acktimeout in
ath9k_hw_init_global_settings where few REG_READ, REG_RMW are also done
and hence the need for PS wrappers

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/main.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2260,7 +2260,11 @@ static void ath9k_set_coverage_class(str
 
 	mutex_lock(&sc->mutex);
 	ah->coverage_class = coverage_class;
+
+	ath9k_ps_wakeup(sc);
 	ath9k_hw_init_global_settings(ah);
+	ath9k_ps_restore(sc);
+
 	mutex_unlock(&sc->mutex);
 }
 


