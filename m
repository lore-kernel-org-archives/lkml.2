Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab2LRDIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 22:08:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab2LRDIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 22:08:39 -0500
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: fengguang.wu@intel.com, Jason Wang <jasowang@redhat.com>
Subject: [PATCH] tuntap: fix sparse warning
Date: Tue, 18 Dec 2012 11:00:27 +0800
Message-Id: <1355799627-55529-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make tun_enable_queue() static to fix the sparse warning:

drivers/net/tun.c:399:19: sparse: symbol 'tun_enable_queue' was not declared. Should it be static?

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/tun.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 173acf5..504f7f1 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -396,7 +396,7 @@ static void tun_disable_queue(struct tun_struct *tun, struct tun_file *tfile)
 	++tun->numdisabled;
 }
 
-struct tun_struct *tun_enable_queue(struct tun_file *tfile)
+static struct tun_struct *tun_enable_queue(struct tun_file *tfile)
 {
 	struct tun_struct *tun = tfile->detached;
 
-- 
1.7.1

