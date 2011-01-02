Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab1ABHxD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:53:03 -0500
Received: from mail.windriver.com ([147.11.1.11]:35598 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab1ABHX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:29 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 124/260] drivers/net/eql.c: prevent reading uninitialized stack memory
Date: Sun,  2 Jan 2011 02:17:00 -0500
Message-Id: <1293952756-15010-125-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:25.0056 (UTC) FILETIME=[CDB49A00:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit 44467187dc22fdd33a1a06ea0ba86ce20be3fe3c upstream.

Fixed formatting (tabs and line breaks).

The EQL_GETMASTRCFG device ioctl allows unprivileged users to read 16
bytes of uninitialized stack memory, because the "master_name" member of
the master_config_t struct declared on the stack in eql_g_master_cfg()
is not altered or zeroed before being copied back to the user.  This
patch takes care of it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/eql.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/eql.c b/drivers/net/eql.c
index b34a2dd..a8b982d 100644
--- a/drivers/net/eql.c
+++ b/drivers/net/eql.c
@@ -555,6 +555,8 @@ static int eql_g_master_cfg(struct net_device *dev, master_config_t __user *mcp)
 	equalizer_t *eql;
 	master_config_t mc;
 
+	memset(&mc, 0, sizeof(master_config_t));
+
 	if (eql_is_master(dev)) {
 		eql = netdev_priv(dev);
 		mc.max_slaves = eql->max_slaves;
-- 
1.7.3.3

