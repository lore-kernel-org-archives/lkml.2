Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030725Ab2HQD3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:29:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46848 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030600Ab2HQD1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:27:08 -0400
Message-Id: <20120817030247.363649141@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 17 Aug 2012 04:03:06 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 23/37] rt61pci: fix NULL pointer dereference in config_lna_gain
In-Reply-To: <20120817030243.807605523@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit deee0214def5d8a32b8112f11d9c2b1696e9c0cb upstream.

We can not pass NULL libconf->conf->channel to rt61pci_config() as it
is dereferenced unconditionally in rt61pci_config_lna_gain() subroutine.

Resolves:
https://bugzilla.kernel.org/show_bug.cgi?id=44361

Reported-and-tested-by: <dolohow@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/rt2x00/rt61pci.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index f322596..3f7bc5c 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2243,8 +2243,7 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 
 static void rt61pci_wakeup(struct rt2x00_dev *rt2x00dev)
 {
-	struct ieee80211_conf conf = { .flags = 0 };
-	struct rt2x00lib_conf libconf = { .conf = &conf };
+	struct rt2x00lib_conf libconf = { .conf = &rt2x00dev->hw->conf };
 
 	rt61pci_config(rt2x00dev, &libconf, IEEE80211_CONF_CHANGE_PS);
 }


