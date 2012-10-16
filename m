Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab2JPBks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 21:40:48 -0400
Received: from noserose.net ([66.220.18.76]:40289 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755452Ab2JPBkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 21:40:46 -0400
Date: Mon, 15 Oct 2012 18:40:43 -0700
Message-Id: <bee64f03a543aff4fa2869b4591b24dccc473f1b.1350331035.git.ecashin@coraid.com>
In-Reply-To: <cover.1350331035.git.ecashin@coraid.com>
References: <cover.1350331035.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 1/9] aoe: describe the behavior of the "err" character device
To: akpm@linux-foundation.org
Cc: ecashin@coraid.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoechr.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/block/aoe/aoechr.c b/drivers/block/aoe/aoechr.c
index ed57a89..2bf6273 100644
--- a/drivers/block/aoe/aoechr.c
+++ b/drivers/block/aoe/aoechr.c
@@ -39,6 +39,11 @@ struct ErrMsg {
 };
 
 static DEFINE_MUTEX(aoechr_mutex);
+
+/* A ring buffer of error messages, to be read through
+ * "/dev/etherd/err".  When no messages are present,
+ * readers will block waiting for messages to appear.
+ */
 static struct ErrMsg emsgs[NMSG];
 static int emsgs_head_idx, emsgs_tail_idx;
 static struct completion emsgs_comp;
-- 
1.7.1

