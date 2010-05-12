Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab0ELItm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 04:49:42 -0400
Received: from www84.your-server.de ([213.133.104.84]:54483 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab0ELItl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 04:49:41 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       andi@firstfloor.org, gregkh@suse.de, alan@lxorguk.ukuu.org.uk,
       tytso@mit.edu, iws@ovro.caltech.edu
Cc: stefani@seibold.net
Subject: [PATCH 1/4] fix kfifo miss use of nozami.c
Date: Wed, 12 May 2010 10:49:24 +0200
Message-Id: <1273654167-31067-2-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1273654167-31067-1-git-send-email-stefani@seibold.net>
References: <1273654167-31067-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

User of the kernel fifo should never bypass the API and directly access
the fifo structure. Otherwise it will be very hard to maintain the API.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 drivers/char/nozomi.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index a663800..d578449 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -1741,8 +1741,7 @@ static int ntty_write_room(struct tty_struct *tty)
 	if (dc) {
 		mutex_lock(&port->tty_sem);
 		if (port->port.count)
-			room = port->fifo_ul.size -
-					kfifo_len(&port->fifo_ul);
+			room = kfifo_avail(&port->fifo_ul);
 		mutex_unlock(&port->tty_sem);
 	}
 	return room;
-- 
1.7.0.4

