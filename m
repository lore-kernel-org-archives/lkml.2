Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab0IORl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 13:41:59 -0400
Received: from mail.perches.com ([173.55.12.10]:2066 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753847Ab0IORl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 13:41:58 -0400
Subject: [RFC PATCH] drivers/net/tg3.c: Raise Jumbo Frame MTU to 9216?
From: Joe Perches <joe@perches.com>
To: Matt Carlson <mcarlson@broadcom.com>, Michael Chan <mchan@broadcom.com>,
        Benjamin Li <benli@broadcom.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 10:41:56 -0700
Message-ID: <1284572516.10223.12.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TG3 apparently supports 9K frame sizes.

http://www.broadcom.com/collateral/pb/5704C-PB05-R.pdf

Is exactly 9000 a hardware limit?

Should the jumbo frame MTU be raised to 9216 or 9216
less the size of MAC, VLAN, IP and TCP headers?

diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index 9f6ffff..3727070 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -95,7 +95,7 @@
 /* hardware minimum and maximum for a single frame's data payload */
 #define TG3_MIN_MTU			60
 #define TG3_MAX_MTU(tp)	\
-	((tp->tg3_flags & TG3_FLAG_JUMBO_CAPABLE) ? 9000 : 1500)
+	((tp->tg3_flags & TG3_FLAG_JUMBO_CAPABLE) ? 9216 : 1500)
 
 /* These numbers seem to be hard coded in the NIC firmware somehow.
  * You can't change the ring sizes, but you can change where you place


