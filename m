Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab0C3XeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:34:21 -0400
Received: from kroah.org ([198.145.64.141]:46494 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756866Ab0C3XVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:21:15 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:31 2010
Message-Id: <20100330224831.414726639@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Senthil Balasubramanian <senthilkumar@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [108/156] ath9k: configure the beacon only if the STA is associated
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Senthil Balasubramanian <senthilkumar@atheros.com>

commit 1a20034a73a40b8056731f9db0c535cec2961eb7 upstream.

beacons configuration SHOULD be done only if the STA is associated.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/beacon.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -573,6 +573,13 @@ static void ath_beacon_config_sta(struct
 	u64 tsf;
 	int num_beacons, offset, dtim_dec_count, cfp_dec_count;
 
+	/* No need to configure beacon if we are not associated */
+	if (!common->curaid) {
+		ath_print(common, ATH_DBG_BEACON,
+			 "STA is not yet associated..skipping beacon config\n");
+		return;
+	}
+
 	memset(&bs, 0, sizeof(bs));
 	intval = conf->beacon_interval & ATH9K_BEACON_PERIOD;
 


