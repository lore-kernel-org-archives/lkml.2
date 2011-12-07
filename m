Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab1LGQnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:43:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33943 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933501Ab1LGQWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:22:07 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:18 2011
Message-Id: <20111207161218.149989523@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:43 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Gertjan van Wingerde <gwingerde@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Ivo van Doorn <IvDoorn@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [041/104] rt2x00: Fix efuse EEPROM reading on PPC32.
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gertjan van Wingerde <gwingerde@gmail.com>

commit 68fa64ef606bcee688fce46d07aa68f175070156 upstream.

Fix __le32 to __le16 conversion of the first word of an 8-word block
of EEPROM read via the efuse method.

Reported-and-tested-by: Ingvar Hagelund <ingvar@redpill-linpro.com>
Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3699,7 +3699,7 @@ static void rt2800_efuse_read(struct rt2
 	/* Apparently the data is read from end to start */
 	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA3, &reg);
 	/* The returned value is in CPU order, but eeprom is le */
-	rt2x00dev->eeprom[i] = cpu_to_le32(reg);
+	*(u32 *)&rt2x00dev->eeprom[i] = cpu_to_le32(reg);
 	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA2, &reg);
 	*(u32 *)&rt2x00dev->eeprom[i + 2] = cpu_to_le32(reg);
 	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA1, &reg);


