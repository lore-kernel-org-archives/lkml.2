Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007Ab1BPBmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:42:17 -0500
Received: from kroah.org ([198.145.64.141]:38933 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756939Ab1BPATr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:19:47 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:31 2011
Message-Id: <20110216001431.731241789@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rajkumar Manoharan <rmanoharan@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [066/272] ath: Missed to clear key4 of micentry
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rajkumar Manoharan <rmanoharan@atheros.com>

commit 998d516d9546eba04dd99ae49a78acb0cf770478 upstream.

key4 of micentry is used, if ATH_CRYPT_CAP_MIC_COMBINED is set.
But is not cleared on key cache reset.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/key.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/ath/key.c
+++ b/drivers/net/wireless/ath/key.c
@@ -60,6 +60,8 @@ bool ath_hw_keyreset(struct ath_common *
 		REG_WRITE(ah, AR_KEYTABLE_KEY1(micentry), 0);
 		REG_WRITE(ah, AR_KEYTABLE_KEY2(micentry), 0);
 		REG_WRITE(ah, AR_KEYTABLE_KEY3(micentry), 0);
+		if (common->crypt_caps & ATH_CRYPT_CAP_MIC_COMBINED)
+			REG_WRITE(ah, AR_KEYTABLE_KEY4(micentry), 0);
 
 	}
 


