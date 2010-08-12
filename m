Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760633Ab0HLUqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 16:46:53 -0400
Received: from www84.your-server.de ([213.133.104.84]:58285 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063Ab0HLUqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 16:46:52 -0400
Subject: Re: [PATCH 2/2] kfifo: add kfifo_skip() testcase
From: Stefani Seibold <stefani@seibold.net>
To: Andrea Righi <arighi@develer.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1281627158-9461-2-git-send-email-arighi@develer.com>
References: <1281627158-9461-1-git-send-email-arighi@develer.com>
	 <1281627158-9461-2-git-send-email-arighi@develer.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 12 Aug 2010 22:46:50 +0200
Message-ID: <1281646010.10603.14.camel@wall-e.seibold.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a testcase for kfifo_skip() to the byte stream fifo example.

Signed-off-by: Andrea Righi <arighi@develer.com>
Acked-by: Stefani Seibold <stefani@seibold.net>
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


