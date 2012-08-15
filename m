Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169Ab2HOTws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:52:48 -0400
Received: from mail1.windriver.com ([147.11.146.13]:63130 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab2HOTwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:52:39 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: "Luck, Tony" <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 146/165] fix typo/thinko in get_random_bytes()
Date: Wed, 15 Aug 2012 15:48:10 -0400
Message-ID: <1345060109-9187-147-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luck, Tony" <tony.luck@intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
---
 drivers/char/random.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 6da0696..df4eb6d 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -934,7 +934,7 @@ void get_random_bytes(void *buf, int nbytes)
 		if (!arch_get_random_long(&v))
 			break;
 
-		memcpy(buf, &v, chunk);
+		memcpy(p, &v, chunk);
 		p += chunk;
 		nbytes -= chunk;
 	}
-- 
1.7.12.rc2

