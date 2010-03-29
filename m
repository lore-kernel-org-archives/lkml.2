Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab0C2Gx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 02:53:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671Ab0C2Gx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 02:53:26 -0400
From: Dave Airlie <airlied@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Airlie <airlied@redhat.com>, David Howells <dhowells@redhat.com>
Subject: [PATCH] slow-work: use get_ref wrapper instead of directly calling get_ref
Date: Mon, 29 Mar 2010 16:51:42 +1000
Message-Id: <1269845502-10163-1-git-send-email-airlied@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise we can get an oops if the user has no get_ref/put_ref
requirement.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 kernel/slow-work.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/slow-work.c b/kernel/slow-work.c
index 7494bbf..7d3f4fa 100644
--- a/kernel/slow-work.c
+++ b/kernel/slow-work.c
@@ -637,7 +637,7 @@ int delayed_slow_work_enqueue(struct delayed_slow_work *dwork,
 			goto cancelled;
 
 		/* the timer holds a reference whilst it is pending */
-		ret = work->ops->get_ref(work);
+		ret = slow_work_get_ref(work);
 		if (ret < 0)
 			goto cant_get_ref;
 
-- 
1.6.5.2

