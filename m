Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab0JRGfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 02:35:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38223 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240Ab0JRGfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 02:35:47 -0400
Date: Mon, 18 Oct 2010 17:35:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Felix Fietkau <nbd@openwrt.org>
Subject: linux-next: manual merge of the bkl-llseek tree with the wireless
 tree
Message-Id: <20101018173543.c33530e9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Today's linux-next merge of the bkl-llseek tree got a conflict in
drivers/net/wireless/ath/ath9k/debug.c between commit
772d5515635fef5bc7a9d0efee785b58b0181ee5 ("ath9k: make rate control
debugfs stats per station") from the wireless tree and commit
6038f373a3dc1f1c26496e60b6c40b164716f07e ("llseek: automatically
add .llseek fop") from the bkl-llseek tree.

The former moved some of the code modified by the latter to another file.

I added this merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 18 Oct 2010 17:33:25 +1100
Subject: [PATCH] ath9k: fix up for .llseek fop change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/wireless/ath/ath9k/rc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 0cee90c..e4c1ea3 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1582,7 +1582,8 @@ static ssize_t read_file_rcstat(struct file *file, char __user *user_buf,
 static const struct file_operations fops_rcstat = {
 	.read = read_file_rcstat,
 	.open = ath9k_debugfs_open,
-	.owner = THIS_MODULE
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
 };
 
 static void ath_rate_add_sta_debugfs(void *priv, void *priv_sta,
-- 
1.7.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
