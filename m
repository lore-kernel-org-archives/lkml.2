Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab0HCRE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 13:04:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63439 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437Ab0HCRE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 13:04:27 -0400
From: Stefan Weil <weil@mail.berlios.de>
To: linux-kernel@vger.kernel.org
Cc: Stefan Weil <weil@mail.berlios.de>,
        "David S. Miller" <davem@davemloft.net>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: [PATCH] phy: Add missing forward declaration (fixes compiler warning)
Date: Tue,  3 Aug 2010 19:04:01 +0200
Message-Id: <1280855041-4063-1-git-send-email-weil@mail.berlios.de>
X-Mailer: git-send-email 1.7.1
X-Provags-ID: V02:K0:K58CGAJuuFdweiLlAj8cCcMoYk0cJbF3jhKC/6HuGIt
 8KnuLZThz9gQ7jh7BCzC8KhmOC0GUmcjiIceT8EeP/3rQkYA40
 NL8v4QE82hX39QE3+wV+nOblEuCOx7XHAGkDGzh0bRQzRy/O6B
 dEkFBKt2KSzrBeEphgrGviXKBFRUmG/YowgrY72Rl4YHPTLBVg
 fVYYaxQ3R+gvEll071WYEZ9TJ4LwJ87iiIZntzkG+d+/SvJ2zD
 HGnFKOytZ16IX
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without forward declaration for struct sk_buff, compilation
of drivers/net/phy/fixed.c results in a warning:

  CC      drivers/net/phy/fixed.o
In file included from drivers/net/phy/fixed.c:20:
include/linux/phy.h:342: warning: 'struct sk_buff' declared inside parameter list
include/linux/phy.h:342: warning: its scope is only this definition or declaration, which is probably not what you want
include/linux/phy.h:343: warning: 'struct sk_buff' declared inside parameter list

(tested with linux kernel for openwrt / ar7, gcc-4.1.2)

Cc: David S. Miller <davem@davemloft.net>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Stefan Weil <weil@mail.berlios.de>
---
 include/linux/phy.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 987e111..65e8d72 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -51,6 +51,8 @@
 #define PHY_HAS_INTERRUPT	0x00000001
 #define PHY_HAS_MAGICANEG	0x00000002
 
+struct sk_buff;
+
 /* Interface Mode definitions */
 typedef enum {
 	PHY_INTERFACE_MODE_MII,
-- 
1.5.6.5

