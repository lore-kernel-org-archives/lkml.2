Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab0IHV33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 17:29:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53108 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083Ab0IHV3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 17:29:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SJd9AGdP7nQE3+yJk+2enrjeX/ifZztC9/5n58HSHmEkrQDubVrgDKWCMCN6XZQmIl
         FyNcYHUcNXgiZedOlyXnSXsOMrEhX7jJ9avwxYe+qxEHvZvHjERFiHtBOm2P1h3/6DzD
         2nZiv9X82wQBBHVzE1UORFoKkES4PhNAkh6gU=
From: Nikitas Angelinas <nikitasangelinas@gmail.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com, davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Nikitas Angelinas <nikitasangelinas@gmail.com>
Subject: [PATCH 8/8] net/wireless: use ARRAY_SIZE macro in radiotap.c
Date: Wed,  8 Sep 2010 22:29:53 +0100
Message-Id: <1283981393-5134-1-git-send-email-nikitasangelinas@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1283979457-4649-1-git-send-email-nikitasangelinas@gmail.com>
References: <1283979457-4649-1-git-send-email-nikitasangelinas@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace sizeof(rtap_namespace_sizes) / sizeof(rtap_namespace_sizes[0])
with ARRAY_SIZE(rtap_namespace_sizes) in net/wireless/radiotap.c

Signed-off-by: Nikitas Angelinas <nikitasangelinas@gmail.com>
---
 net/wireless/radiotap.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/wireless/radiotap.c b/net/wireless/radiotap.c
index 1332c44..c774bc0 100644
--- a/net/wireless/radiotap.c
+++ b/net/wireless/radiotap.c
@@ -14,6 +14,7 @@
  * See COPYING for more details.
  */
 
+#include <linux/kernel.h>
 #include <net/cfg80211.h>
 #include <net/ieee80211_radiotap.h>
 #include <asm/unaligned.h>
@@ -45,7 +46,7 @@ static const struct radiotap_align_size rtap_namespace_sizes[] = {
 };
 
 static const struct ieee80211_radiotap_namespace radiotap_ns = {
-	.n_bits = sizeof(rtap_namespace_sizes) / sizeof(rtap_namespace_sizes[0]),
+	.n_bits = ARRAY_SIZE(rtap_namespace_sizes),
 	.align_size = rtap_namespace_sizes,
 };
 
-- 
1.7.2.3

