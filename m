Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab2GWBm0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:42:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53960 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752856Ab2GWBmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:42:11 -0400
Message-Id: <20120723010653.341677646@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:03 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Russell Coker <russell@coker.com.au>
Subject: [ 012/108] ext4: Report max_batch_time option correctly
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 1d526fc91bea04ee35b7599bf8b82f86c0aaf46c upstream.

Currently the value reported for max_batch_time is really the
value of min_batch_time.

Reported-by: Russell Coker <russell@coker.com.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 35377d5..36570b7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1096,7 +1096,7 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	}
 	if (sbi->s_max_batch_time != EXT4_DEF_MAX_BATCH_TIME) {
 		seq_printf(seq, ",max_batch_time=%u",
-			   (unsigned) sbi->s_min_batch_time);
+			   (unsigned) sbi->s_max_batch_time);
 	}
 
 	/*


