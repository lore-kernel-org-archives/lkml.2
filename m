Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab0C2LCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 07:02:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299Ab0C2LCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 07:02:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] slow-work: use get_ref wrapper instead of directly calling
	get_ref
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-cachefs@redhat.com, linux-kernel@vger.kernel.org,
       Dave Airlie <airlied@redhat.com>, David Howells <dhowells@redhat.com>
Date: Mon, 29 Mar 2010 12:01:50 +0100
Message-ID: <20100329110150.14738.2830.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

Otherwise we can get an oops if the user has no get_ref/put_ref
requirement.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
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
 

