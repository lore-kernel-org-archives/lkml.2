Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318Ab1KKBNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 20:13:12 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41677 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933276Ab1KKBNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 20:13:10 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Denis Turischev <denis@compulab.co.il>
Cc: linux-kernel@vger.kernel.org, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 2/2] pch_phub: Fix MAC address writing issue for LAPIS ML7831
Date: Fri, 11 Nov 2011 10:12:18 +0900
Message-Id: <1320973938-5629-2-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1320973938-5629-1-git-send-email-tomoya.rohm@gmail.com>
References: <1320973938-5629-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ISSUE:
Using ML7831, MAC address writing doesn't work well.

CAUSE:
ML7831 and EG20T have the same register map for MAC address access.
However, this driver processes the writing the same as ML7223.
This is not true.
This driver must process the writing the same as EG20T.
This patch fixes the issue.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/misc/pch_phub.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
index 590176d..3a6f171 100644
--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -473,7 +473,7 @@ static int pch_phub_write_gbe_mac_addr(struct pch_phub_reg *chip, u8 *data)
 	int retval;
 	int i;
 
-	if (chip->ioh_type == 1) /* EG20T */
+	if ((chip->ioh_type == 1) || (chip->ioh_type == 5)) /* EG20T or ML7831*/
 		retval = pch_phub_gbe_serial_rom_conf(chip);
 	else	/* ML7223 */
 		retval = pch_phub_gbe_serial_rom_conf_mp(chip);
-- 
1.7.4.4

