Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792Ab2GFWvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 18:51:04 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37465 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756360Ab2GFWu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 18:50:58 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: ewust@umich.edu, zakir@umich.edu, nadiah@cs.ucsd.edu, jhalderm@umich.edu,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 01/12] random: fix up sparse warnings
Date: Fri,  6 Jul 2012 18:44:53 -0400
Message-Id: <1341614704-24965-2-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.11.1.108.gb129051
In-Reply-To: <1341614704-24965-1-git-send-email-tytso@mit.edu>
References: <1341614704-24965-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add extern and static declarations to suppress sparse warnings

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 drivers/char/random.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 4ec04a7..cb541b9 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1279,6 +1279,7 @@ static int proc_do_uuid(ctl_table *table, int write,
 }
 
 static int sysctl_poolsize = INPUT_POOL_WORDS * 32;
+extern ctl_table random_table[];
 ctl_table random_table[] = {
 	{
 		.procname	= "poolsize",
@@ -1344,7 +1345,7 @@ late_initcall(random_int_secret_init);
  * value is not cryptographically secure but for several uses the cost of
  * depleting entropy is too high
  */
-DEFINE_PER_CPU(__u32 [MD5_DIGEST_WORDS], get_random_int_hash);
+static DEFINE_PER_CPU(__u32 [MD5_DIGEST_WORDS], get_random_int_hash);
 unsigned int get_random_int(void)
 {
 	__u32 *hash;
-- 
1.7.11.1.108.gb129051

