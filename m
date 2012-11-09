Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422691Ab2KICW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 21:22:26 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53950 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756999Ab2KICWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 21:22:22 -0500
Message-ID: <509C68D7.8040603@gmail.com>
Date: Fri, 09 Nov 2012 10:22:15 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: lindner_marek@yahoo.de, siwu@hrz.tu-chemnitz.de, ordex@autistici.org,
        b.a.t.m.a.n@lists.open-mesh.org, David Miller <davem@davemloft.net>,
        NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        Shan Wei <shanwei88@gmail.com>, Christoph Lameter <cl@linux.com>
Subject: [PATCH v3 9/9] net: batman-adv: use per_cpu_add helper
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shan Wei <davidshan@tencent.com>

this_cpu_add is an atomic operation.
and be more faster than per_cpu_ptr operation.

Signed-off-by: Shan Wei <davidshan@tencent.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
---
v3: change commit message.
---
 net/batman-adv/main.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/main.h b/net/batman-adv/main.h
index 897ba6a..3aef5b2 100644
--- a/net/batman-adv/main.h
+++ b/net/batman-adv/main.h
@@ -263,9 +263,7 @@ static inline bool batadv_has_timed_out(unsigned long timestamp,
 static inline void batadv_add_counter(struct batadv_priv *bat_priv, size_t idx,
 				      size_t count)
 {
-	int cpu = get_cpu();
-	per_cpu_ptr(bat_priv->bat_counters, cpu)[idx] += count;
-	put_cpu();
+	this_cpu_add(bat_priv->bat_counters[idx], count);
 }
 
 #define batadv_inc_counter(b, i) batadv_add_counter(b, i, 1)
-- 
1.7.1


