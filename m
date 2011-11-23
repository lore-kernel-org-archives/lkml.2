Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231Ab1KWAkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:40:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42809 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759202Ab1KWAki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:40:38 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:24:06 2011
Message-Id: <20111123002406.205761353@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:23:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Masayuki Ohtak <masa-korg@dsn.okisemi.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Denis Turischev <denis@compulab.co.il>
Subject: [17/53] pch_phub: Fix MAC address writing issue for LAPIS ML7831
In-Reply-To: <20111123002419.GA8531@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya.rohm@gmail.com>

commit 2a9887919457c6e1bd482e8448223be59d19010a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/pch_phub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -467,7 +467,7 @@ static int pch_phub_write_gbe_mac_addr(s
 	int retval;
 	int i;
 
-	if (chip->ioh_type == 1) /* EG20T */
+	if ((chip->ioh_type == 1) || (chip->ioh_type == 5)) /* EG20T or ML7831*/
 		retval = pch_phub_gbe_serial_rom_conf(chip);
 	else	/* ML7223 */
 		retval = pch_phub_gbe_serial_rom_conf_mp(chip);


