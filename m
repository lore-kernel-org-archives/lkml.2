Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab2HMWGD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:06:03 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61572 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994Ab2HMWF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:05:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 44/44] rt61pci: fix NULL pointer dereference in config_lna_gain
Date: Mon, 13 Aug 2012 15:02:51 -0700
Message-Id: <20120813220146.021820736@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813220142.113186818@linuxfoundation.org>
References: <20120813220142.113186818@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt61pci.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2254,8 +2254,7 @@ static void rt61pci_txdone(struct rt2x00
 
 static void rt61pci_wakeup(struct rt2x00_dev *rt2x00dev)
 {
-	struct ieee80211_conf conf = { .flags = 0 };
-	struct rt2x00lib_conf libconf = { .conf = &conf };
+	struct rt2x00lib_conf libconf = { .conf = &rt2x00dev->hw->conf };
 
 	rt61pci_config(rt2x00dev, &libconf, IEEE80211_CONF_CHANGE_PS);
 }


