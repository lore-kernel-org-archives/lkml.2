Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab0ICKcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 06:32:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099Ab0ICKca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 06:32:30 -0400
Date: Fri, 3 Sep 2010 13:25:43 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Tejun Heo <tj@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        kvm@vger.kernel.org, virtualization@lists.osdl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] vhost: error handling fix
Message-ID: <20100903102543.GA31883@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vhost should set worker to NULL on cgroups attach failure,
so that we won't try to destroy the worker again on close.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Dave, no need to bother with this one unless you really want to -
I'll put it on my tree.

This is a follow up to Eric's patch - fixes error handling in a similar way.

 drivers/vhost/vhost.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 7c75dce..666aa36 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -298,6 +298,7 @@ static long vhost_dev_set_owner(struct vhost_dev *dev)
 	return 0;
 err_cgroup:
 	kthread_stop(worker);
+	dev->worker = NULL;
 err_worker:
 	if (dev->mm)
 		mmput(dev->mm);
-- 
1.7.2.rc0.14.g41c1c
