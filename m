Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab1HCXkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:40:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33708 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756067Ab1HCX2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:28:01 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:46 2011
Message-Id: <20110803221246.712194716@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:00:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roland Vossen <rvossen@broadcom.com>,
        Stefan Lippers-Hollmann <s.l-h@gmx.de>
Subject: [027/102] staging: brcm80211: fix for reported log spam problem
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roland Vossen <rvossen@broadcom.com>

commit 37c962d195005d009e130e65a9e55960996c3cab upstream.

Every few minutes, this message would appear in syslog:

ieee80211 ph0: wl_ops_bss_info_changed: BSS idle: true (implement)

The message has been deleted, the driver requires no special action on this
particular event (). See: https://bugzilla.kernel.org/show_bug.cgi?id=38162

Reported-by: David Hill <hilld@binarystorm.net>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>

---
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -449,11 +449,6 @@ wl_ops_bss_info_changed(struct ieee80211
 		wiphy_err(wiphy, "%s: qos enabled: %s (implement)\n", __func__,
 			  info->qos ? "true" : "false");
 	}
-	if (changed & BSS_CHANGED_IDLE) {
-		/* Idle changed for this BSS/interface */
-		wiphy_err(wiphy, "%s: BSS idle: %s (implement)\n", __func__,
-			  info->idle ? "true" : "false");
-	}
 	return;
 }
 


