Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab1KPSu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 13:50:58 -0500
Received: from mga03.intel.com ([143.182.124.21]:14691 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336Ab1KPSu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 13:50:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,522,1315206000"; 
   d="scan'208";a="75776872"
From: "Luck, Tony" <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Ts'o" <tytso@mit.edu>, Jeff Garzik <jgarzik@pobox.com>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] fix typo/thinko in get_random_bytes()
Date: Wed, 16 Nov 2011 10:50:56 -0800
Message-Id: <4ec4061010261a4cb0@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there is an architecture-specific random number generator we use
it to acquire randomness one "long" at a time. We should put these
random words into consecutive words in the result buffer - not just
overwrite the first word again and again.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 63e19ba..6035ab8 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -941,7 +941,7 @@ void get_random_bytes(void *buf, int nbytes)
 		if (!arch_get_random_long(&v))
 			break;
 		
-		memcpy(buf, &v, chunk);
+		memcpy(p, &v, chunk);
 		p += chunk;
 		nbytes -= chunk;
 	}
