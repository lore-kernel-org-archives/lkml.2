Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab1G0J4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 05:56:38 -0400
Received: from narfation.org ([79.140.41.39]:43150 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121Ab1G0Jzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 05:55:50 -0400
From: Sven Eckelmann <sven@narfation.org>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <lindner_marek@yahoo.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: [PATCHv4 02/11] batman-adv: Remove private define of atomic_dec_not_zero
Date: Wed, 27 Jul 2011 11:47:41 +0200
Message-Id: <1311760070-21532-2-git-send-email-sven@narfation.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1311760070-21532-1-git-send-email-sven@narfation.org>
References: <1311760070-21532-1-git-send-email-sven@narfation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

atomic_dec_not_zero is defined through <linux/atomic.h> for all
architectures and batman-adv doesn't need an extra define which may
collide with the global one.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Cc: Marek Lindner <lindner_marek@yahoo.de>
Cc: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Cc: b.a.t.m.a.n@lists.open-mesh.org
---
 net/batman-adv/main.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/batman-adv/main.h b/net/batman-adv/main.h
index a6df61a..d986f34 100644
--- a/net/batman-adv/main.h
+++ b/net/batman-adv/main.h
@@ -201,8 +201,6 @@ static inline int compare_eth(const void *data1, const void *data2)
 }
 
 
-#define atomic_dec_not_zero(v)	atomic_add_unless((v), -1, 0)
-
 /* Returns the smallest signed integer in two's complement with the sizeof x */
 #define smallest_signed_int(x) (1u << (7u + 8u * (sizeof(x) - 1u)))
 
-- 
1.7.5.4

