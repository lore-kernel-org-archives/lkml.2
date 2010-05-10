Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387Ab0EJXiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:38:01 -0400
Received: from kroah.org ([198.145.64.141]:33075 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932407Ab0EJWwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:13 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:21 2010
Message-Id: <20100510223321.440874092@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:32:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Korsgaard <jacmet@sunsite.dk>,
       "David S. Miller" <davem@davemloft.net>
Subject: [047/117] dm9601: fix phy/eeprom write routine
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Korsgaard <jacmet@sunsite.dk>

commit e9162ab1610531d6ea6c1833daeb2613e44275e8 upstream.

Use correct bit positions in DM_SHARED_CTRL register for writes.

Michael Planes recently encountered a 'KY-RS9600 USB-LAN converter', which
came with a driver CD containing a Linux driver. This driver turns out to
be a copy of dm9601.c with symbols renamed and my copyright stripped.
That aside, it did contain 1 functional change in dm_write_shared_word(),
and after checking the datasheet the original value was indeed wrong
(read versus write bits).

On Michaels HW, this change bumps receive speed from ~30KB/s to ~900KB/s.
On other devices the difference is less spectacular, but still significant
(~30%).

Reported-by: Michael Planes <michael.planes@free.fr>
Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/usb/dm9601.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/usb/dm9601.c
+++ b/drivers/net/usb/dm9601.c
@@ -238,7 +238,7 @@ static int dm_write_shared_word(struct u
 		goto out;
 
 	dm_write_reg(dev, DM_SHARED_ADDR, phy ? (reg | 0x40) : reg);
-	dm_write_reg(dev, DM_SHARED_CTRL, phy ? 0x1c : 0x14);
+	dm_write_reg(dev, DM_SHARED_CTRL, phy ? 0x1a : 0x12);
 
 	for (i = 0; i < DM_TIMEOUT; i++) {
 		u8 tmp;


