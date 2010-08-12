Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933833Ab0HLPcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 11:32:54 -0400
Received: from trinity.develer.com ([83.149.158.210]:32932 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933717Ab0HLPcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 11:32:48 -0400
From: Andrea Righi <arighi@develer.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] kfifo: add kfifo_skip() testcase
Date: Thu, 12 Aug 2010 17:32:38 +0200
Message-Id: <1281627158-9461-2-git-send-email-arighi@develer.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1281627158-9461-1-git-send-email-arighi@develer.com>
References: <1281627158-9461-1-git-send-email-arighi@develer.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a testcase for kfifo_skip() to the byte stream fifo example.

Signed-off-by: Andrea Righi <arighi@develer.com>
---
 samples/kfifo/bytestream-example.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/samples/kfifo/bytestream-example.c b/samples/kfifo/bytestream-example.c
index 642eef3..2e3a7a8 100644
--- a/samples/kfifo/bytestream-example.c
+++ b/samples/kfifo/bytestream-example.c
@@ -73,6 +73,10 @@ static int __init testfunc(void)
 	ret = kfifo_in(&test, buf, ret);
 	printk(KERN_INFO "ret: %d\n", ret);
 
+	/* skip first element of the fifo */
+	printk(KERN_INFO "skip 1st element\n");
+	kfifo_skip(&test);
+
 	/* put values into the fifo until is full */
 	for (i = 20; kfifo_put(&test, &i); i++)
 		;
-- 
1.7.0.4

