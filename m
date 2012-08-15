Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389Ab2HOTuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:50:17 -0400
Received: from mail.windriver.com ([147.11.1.11]:36721 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506Ab2HOTuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:09 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Guy Martin <gmsoft@tuxicoman.be>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Matt Turner <mattst88@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 041/165] e1000: Fix driver to be used on PA RISC C8000 workstations
Date: Wed, 15 Aug 2012 15:46:25 -0400
Message-ID: <1345060109-9187-42-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/e1000/e1000_hw.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/e1000/e1000_hw.c b/drivers/net/e1000/e1000_hw.c
index 8d7d87f..0d82be0 100644
--- a/drivers/net/e1000/e1000_hw.c
+++ b/drivers/net/e1000/e1000_hw.c
@@ -3842,6 +3842,12 @@ s32 e1000_validate_eeprom_checksum(struct e1000_hw *hw)
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
-- 
1.7.12.rc2

