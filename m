Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848Ab1KVBLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 20:11:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41122 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757467Ab1KVBLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 20:11:18 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Masayuki Ohtak <masa-korg@dsn.okisemi.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Denis Turischev <denis@compulab.co.il>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 6/7] pch_phub: Fix MAC address writing issue for LAPIS ML7831
Date: Mon, 21 Nov 2011 17:10:33 -0800
Message-Id: <1321924234-26258-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1321924234-26258-1-git-send-email-gregkh@suse.de>
References: <20111122005836.GA25420@kroah.com>
 <1321924234-26258-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomoya MORINAGA <tomoya.rohm@gmail.com>

ISSUE:
Using ML7831, MAC address writing doesn't work well.

CAUSE:
ML7831 and EG20T have the same register map for MAC address access.
However, this driver processes the writing the same as ML7223.
This is not true.
This driver must process the writing the same as EG20T.
This patch fixes the issue.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Denis Turischev <denis@compulab.co.il>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/misc/pch_phub.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
index 0e2c181..10fc478 100644
--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -476,7 +476,7 @@ static int pch_phub_write_gbe_mac_addr(struct pch_phub_reg *chip, u8 *data)
 	int retval;
 	int i;
 
-	if (chip->ioh_type == 1) /* EG20T */
+	if ((chip->ioh_type == 1) || (chip->ioh_type == 5)) /* EG20T or ML7831*/
 		retval = pch_phub_gbe_serial_rom_conf(chip);
 	else	/* ML7223 */
 		retval = pch_phub_gbe_serial_rom_conf_mp(chip);
-- 
1.7.7.3

