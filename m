Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab0FDUrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 16:47:32 -0400
Received: from kroah.org ([198.145.64.141]:43996 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020Ab0FDUra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 16:47:30 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/3] lib/kobject_uevent.c: fix CONIG_NET=n warning
Date: Fri,  4 Jun 2010 13:47:27 -0700
Message-Id: <1275684449-20061-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100604204450.GC19761@kroah.com>
References: <20100604204450.GC19761@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

lib/kobject_uevent.c:87: warning: 'kobj_bcast_filter' defined but not used

Repairs "hotplug: netns aware uevent_helper"

Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject_uevent.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 59c1551..e2eb989 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -83,6 +83,7 @@ out:
 	return ret;
 }
 
+#ifdef CONFIG_NET
 static int kobj_bcast_filter(struct sock *dsk, struct sk_buff *skb, void *data)
 {
 	struct kobject *kobj = data;
@@ -98,6 +99,7 @@ static int kobj_bcast_filter(struct sock *dsk, struct sk_buff *skb, void *data)
 
 	return 0;
 }
+#endif
 
 static int kobj_usermode_filter(struct kobject *kobj)
 {
-- 
1.7.1

