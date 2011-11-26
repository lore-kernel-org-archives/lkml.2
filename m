Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab1KZWe5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 17:34:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57955 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786Ab1KZWez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 17:34:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH] ath9k: Revert change that broke AR928X on Acer Ferrari One
Date: Sat, 26 Nov 2011 23:37:43 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Adrian Chadd <adrian@freebsd.org>
References: <CA+55aFyNUC+k1gp3MQkxQzernEzRZwYOH4EBnOq=6UiaJ2oh4A@mail.gmail.com> <201111250203.29786.rjw@sisk.pl> <201111262232.46195.rjw@sisk.pl>
In-Reply-To: <201111262232.46195.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111262337.43771.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Revert a hunk in drivers/net/wireless/ath/ath9k/hw.c introduced by
commit 2577c6e8f2320f1d2f09be122efef5b9118efee4 (ath9k_hw: Add
support for AR946/8x chipsets) that caused a nasty regression to
appear on my Acer Ferrari One (the box locks up entirely at random
times after the wireless has been started without any way to get
debug information out of it).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/net/wireless/ath/ath9k/hw.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/drivers/net/wireless/ath/ath9k/hw.c
===================================================================
--- linux.orig/drivers/net/wireless/ath/ath9k/hw.c
+++ linux/drivers/net/wireless/ath/ath9k/hw.c
@@ -1827,7 +1827,8 @@ static void ath9k_set_power_sleep(struct
 	}
 
 	/* Clear Bit 14 of AR_WA after putting chip into Full Sleep mode. */
-	REG_WRITE(ah, AR_WA, ah->WARegVal & ~AR_WA_D3_L1_DISABLE);
+	if (AR_SREV_9300_20_OR_LATER(ah))
+		REG_WRITE(ah, AR_WA, ah->WARegVal & ~AR_WA_D3_L1_DISABLE);
 }
 
 /*
