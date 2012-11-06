Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab2KFWVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 17:21:23 -0500
Received: from [93.179.225.50] ([93.179.225.50]:39270 "EHLO shrek.podlesie.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab2KFWUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 17:20:32 -0500
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Chas Williams - CONTRACTOR <chas@cmf.nrl.navy.mil>,
        David Woodhouse <David.Woodhouse@intel.com>, davem@davemloft.net,
        Krzysztof Mazur <krzysiek@podlesie.net>
Subject: [PATCH v3 7/7] pppoatm: do not inline pppoatm_may_send()
Date: Tue,  6 Nov 2012 23:17:02 +0100
Message-Id: <1352240222-363-8-git-send-email-krzysiek@podlesie.net>
X-Mailer: git-send-email 1.8.0.233.g54991f2
In-Reply-To: <1352240222-363-1-git-send-email-krzysiek@podlesie.net>
References: <1352240222-363-1-git-send-email-krzysiek@podlesie.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pppoatm_may_send() is quite heavy and it's called three times
in pppoatm_send() and inlining costs more than 200 bytes of code
(more than 10% of total pppoatm driver code size).

add/remove: 1/0 grow/shrink: 0/1 up/down: 132/-367 (-235)
function                                     old     new   delta
pppoatm_may_send                               -     132    +132
pppoatm_send                                 900     533    -367

Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
---
 net/atm/pppoatm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/atm/pppoatm.c b/net/atm/pppoatm.c
index bf5d6c9..7507c20 100644
--- a/net/atm/pppoatm.c
+++ b/net/atm/pppoatm.c
@@ -214,7 +214,7 @@ error:
 	ppp_input_error(&pvcc->chan, 0);
 }
 
-static inline int pppoatm_may_send(struct pppoatm_vcc *pvcc, int size)
+static int pppoatm_may_send(struct pppoatm_vcc *pvcc, int size)
 {
 	/*
 	 * It's not clear that we need to bother with using atm_may_send()
-- 
1.8.0.233.g54991f2

