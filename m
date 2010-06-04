Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab0FDUrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 16:47:49 -0400
Received: from kroah.org ([198.145.64.141]:44001 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756679Ab0FDUrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 16:47:31 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/3] kobject: free memory if netlink_kernel_create() fails
Date: Fri,  4 Jun 2010 13:47:28 -0700
Message-Id: <1275684449-20061-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100604204450.GC19761@kroah.com>
References: <20100604204450.GC19761@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

There is a kfree(ue_sk) missing on the error path if
netlink_kernel_create() fails.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject_uevent.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index e2eb989..b935795 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -380,6 +380,7 @@ static int uevent_net_init(struct net *net)
 	if (!ue_sk->sk) {
 		printk(KERN_ERR
 		       "kobject_uevent: unable to create netlink socket!\n");
+		kfree(ue_sk);
 		return -ENODEV;
 	}
 	mutex_lock(&uevent_sock_mutex);
-- 
1.7.1

