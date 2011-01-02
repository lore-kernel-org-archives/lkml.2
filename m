Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab1ABHxF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:53:05 -0500
Received: from mail.windriver.com ([147.11.1.11]:35585 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab1ABHX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:29 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 123/260] drivers/net/cxgb3/cxgb3_main.c: prevent reading uninitialized stack memory
Date: Sun,  2 Jan 2011 02:16:59 -0500
Message-Id: <1293952756-15010-124-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:23.0930 (UTC) FILETIME=[CD08C9A0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit 49c37c0334a9b85d30ab3d6b5d1acb05ef2ef6de upstream.

Fixed formatting (tabs and line breaks).

The CHELSIO_GET_QSET_NUM device ioctl allows unprivileged users to read
4 bytes of uninitialized stack memory, because the "addr" member of the
ch_reg struct declared on the stack in cxgb_extension_ioctl() is not
altered or zeroed before being copied back to the user.  This patch
takes care of it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/cxgb3/cxgb3_main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/cxgb3/cxgb3_main.c b/drivers/net/cxgb3/cxgb3_main.c
index e3f1b85..3e0f19f 100644
--- a/drivers/net/cxgb3/cxgb3_main.c
+++ b/drivers/net/cxgb3/cxgb3_main.c
@@ -2296,6 +2296,8 @@ static int cxgb_extension_ioctl(struct net_device *dev, void __user *useraddr)
 	case CHELSIO_GET_QSET_NUM:{
 		struct ch_reg edata;
 
+		memset(&edata, 0, sizeof(struct ch_reg));
+
 		edata.cmd = CHELSIO_GET_QSET_NUM;
 		edata.val = pi->nqsets;
 		if (copy_to_user(useraddr, &edata, sizeof(edata)))
-- 
1.7.3.3

