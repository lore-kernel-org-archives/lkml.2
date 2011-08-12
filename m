Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab1HNQbq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:31:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36206 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539Ab1HNQFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:05:40 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:52 2011
Message-Id: <20110812210552.323286198@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:03:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [02/90] cris: fix a build error in sync_serial_open()
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: WANG Cong <xiyou.wangcong@gmail.com>

commit 4b851d88192c22cf77418a0b4c45b5c789276837 upstream.

Fix:

  arch/cris/arch-v10/drivers/sync_serial.c:628: error: 'ret' undeclared (first use in this function)

'ret' should be 'err'.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/cris/arch-v10/drivers/sync_serial.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/cris/arch-v10/drivers/sync_serial.c
+++ b/arch/cris/arch-v10/drivers/sync_serial.c
@@ -625,11 +625,11 @@ static int sync_serial_open(struct inode
 			*R_IRQ_MASK1_SET = 1 << port->data_avail_bit;
 		DEBUG(printk(KERN_DEBUG "sser%d rec started\n", dev));
 	}
-	ret = 0;
+	err = 0;
 	
 out:
 	mutex_unlock(&sync_serial_mutex);
-	return ret;
+	return err;
 }
 
 static int sync_serial_release(struct inode *inode, struct file *file)


