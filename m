Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933567Ab2JAX3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:29:31 -0400
Received: from 1wt.eu ([62.212.114.60]:35228 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932729Ab2JAXAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:46 -0400
Message-Id: <20121001225204.476606409@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:39 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 162/180] fix typo/thinko in get_random_bytes()
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Luck, Tony <tony.luck@intel.com>

commit bd29e568a4cb6465f6e5ec7c1c1f3ae7d99cbec1 upstream.

If there is an architecture-specific random number generator we use it
to acquire randomness one "long" at a time.  We should put these random
words into consecutive words in the result buffer - not just overwrite
the first word again and again.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/char/random.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 93b3c29..f2a1651 100644
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
-- 
1.7.2.1.45.g54fbc



