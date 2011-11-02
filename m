Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab1KCBdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:33:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50337 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755002Ab1KCBdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:33:13 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:52 2011
Message-Id: <20111102221452.384134289@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:13:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Guy Martin <gmsoft@tuxicoman.be>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Matt Turner <mattst88@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [025/107] e1000: Fix driver to be used on PA RISC C8000 workstations
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

commit e2faeec2de9e2c73958e6ea6065dde1e8cd6f3a2 upstream.

The checksum field in the EEPROM on HPPA is really not a
checksum but a signature (0x16d6).  So allow 0x16d6 as the
matching checksum on HPPA systems.

This issue is present on longterm/stable kernels, I have
verified that this patch is applicable back to at least
2.6.32.y kernels.

v2- changed ifdef to use CONFIG_PARISC instead of __hppa__

CC: Guy Martin <gmsoft@tuxicoman.be>
CC: Rolf Eike Beer <eike-kernel@sf-tec.de>
CC: Matt Turner <mattst88@gmail.com>
Reported-by: Mikulas Patocka <mikulas@artax.kerlin.mff.cuni.cz>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/e1000/e1000_hw.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/e1000/e1000_hw.c
+++ b/drivers/net/e1000/e1000_hw.c
@@ -3842,6 +3842,12 @@ s32 e1000_validate_eeprom_checksum(struc
 		checksum += eeprom_data;
 	}
 
+#ifdef CONFIG_PARISC
+	/* This is a signature and not a checksum on HP c8000 */
+	if ((hw->subsystem_vendor_id == 0x103C) && (eeprom_data == 0x16d6))
+		return E1000_SUCCESS;
+
+#endif
 	if (checksum == (u16) EEPROM_SUM)
 		return E1000_SUCCESS;
 	else {


