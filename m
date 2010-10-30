Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab0J3JE5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 05:04:57 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37337 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab0J3JEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 05:04:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MnGkucGmJpXbKmPEcUQWMOinwA42desOXJdZhEa0PbliPNhv5zjtjoIxFwaLWeHGic
         QqscgRvTubNefLtple25YvI/zPZWXyimNRXRVmK6M6XuENvbmIyjc8iFDDm3taj0J8EI
         /vJJUkuCPSEWc0grqzXz2KEOfy+WhRx0kkim4=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Karsten Keil <isdn@linux-pingi.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        Eric Paris <eparis@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] isdn: mISDN: socket: fix information leak to userland
Date: Sat, 30 Oct 2010 13:04:33 +0400
Message-Id: <1288429473-21864-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structure mISDN_devinfo is copied to userland with the field "name"
that has the last elements unitialized.  It leads to leaking of
contents of kernel stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 drivers/isdn/mISDN/socket.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/isdn/mISDN/socket.c b/drivers/isdn/mISDN/socket.c
index 3232206..7446d8b 100644
--- a/drivers/isdn/mISDN/socket.c
+++ b/drivers/isdn/mISDN/socket.c
@@ -392,6 +392,7 @@ data_sock_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 		if (dev) {
 			struct mISDN_devinfo di;
 
+			memset(&di, 0, sizeof(di));
 			di.id = dev->id;
 			di.Dprotocols = dev->Dprotocols;
 			di.Bprotocols = dev->Bprotocols | get_all_Bprotocols();
@@ -672,6 +673,7 @@ base_sock_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 		if (dev) {
 			struct mISDN_devinfo di;
 
+			memset(&di, 0, sizeof(di));
 			di.id = dev->id;
 			di.Dprotocols = dev->Dprotocols;
 			di.Bprotocols = dev->Bprotocols | get_all_Bprotocols();
-- 
1.7.0.4

