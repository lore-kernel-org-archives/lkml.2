Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab2JOVnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 17:43:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57988 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932086Ab2JOVnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 17:43:37 -0400
Date: Mon, 15 Oct 2012 23:43:29 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [RESEND] [PATCH 2/2] random: fix debug format strings
In-Reply-To: <alpine.LNX.2.00.1210081639340.28357@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1210152343050.14002@pobox.suse.cz>
References: <alpine.LNX.2.00.1210081637170.28357@pobox.suse.cz> <alpine.LNX.2.00.1210081639340.28357@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warnings in formatting debug output:

drivers/char/random.c: In function ¡xfer_secondary_pool¢:
drivers/char/random.c:827: warning: format ¡%d¢ expects type ¡int¢, but argument 7 has type ¡size_t¢
drivers/char/random.c: In function ¡account¢:
drivers/char/random.c:859: warning: format ¡%d¢ expects type ¡int¢, but argument 5 has type ¡size_t¢
drivers/char/random.c:881: warning: format ¡%d¢ expects type ¡int¢, but argument 5 has type ¡size_t¢
drivers/char/random.c: In function ¡random_read¢:
drivers/char/random.c:1141: warning: format ¡%d¢ expects type ¡int¢, but argument 5 has type ¡ssize_t¢
drivers/char/random.c:1145: warning: format ¡%d¢ expects type ¡int¢, but argument 5 has type ¡ssize_t¢
drivers/char/random.c:1145: warning: format ¡%d¢ expects type ¡int¢, but argument 6 has type ¡long unsigned int¢

by using '%zd' instead of '%d' to properly denote ssize_t/size_t conversion.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/char/random.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 9ac4443..5d513c3 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -825,7 +825,7 @@ static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 		bytes = min_t(int, bytes, sizeof(tmp));
 
 		DEBUG_ENT("going to reseed %s with %d bits "
-			  "(%d of %d requested)\n",
+			  "(%zd of %d requested)\n",
 			  r->name, bytes * 8, nbytes * 8, r->entropy_count);
 
 		bytes = extract_entropy(r->pull, tmp, bytes,
@@ -856,7 +856,7 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
 	spin_lock_irqsave(&r->lock, flags);
 
 	BUG_ON(r->entropy_count > r->poolinfo->POOLBITS);
-	DEBUG_ENT("trying to extract %d bits from %s\n",
+	DEBUG_ENT("trying to extract %zd bits from %s\n",
 		  nbytes * 8, r->name);
 
 	/* Can we pull enough? */
@@ -878,7 +878,7 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
 		}
 	}
 
-	DEBUG_ENT("debiting %d entropy credits from %s%s\n",
+	DEBUG_ENT("debiting %zd entropy credits from %s%s\n",
 		  nbytes * 8, r->name, r->limit ? "" : " (unlimited)");
 
 	spin_unlock_irqrestore(&r->lock, flags);
@@ -1138,11 +1138,11 @@ random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 		if (n > SEC_XFER_SIZE)
 			n = SEC_XFER_SIZE;
 
-		DEBUG_ENT("reading %d bits\n", n*8);
+		DEBUG_ENT("reading %zd bits\n", n*8);
 
 		n = extract_entropy_user(&blocking_pool, buf, n);
 
-		DEBUG_ENT("read got %d bits (%d still needed)\n",
+		DEBUG_ENT("read got %zd bits (%zd still needed)\n",
 			  n*8, (nbytes-n)*8);
 
 		if (n == 0) {
-- 
Jiri Kosina
SUSE Labs
