Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762927Ab2DLWgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 18:36:38 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:3853 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757716Ab2DLWgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 18:36:37 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-209.messagelabs.com!1334270195!3073974!2
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] block: blk-ioc.c: local functions should not be exposed globally
Date: Thu, 12 Apr 2012 15:36:24 -0700
User-Agent: KMail/1.9.9
CC: <axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204121536.24685.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function ioc_set_icq_flags is only referenced in this file and
should be marked static to prevent it from being exposed globally.

This quiets the sparse warning:

warning: symbol 'ioc_set_icq_flags' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Jens Axboe <axboe@kernel.dk>

---

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index fb95dd2..167bae0 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -382,7 +382,7 @@ struct io_cq *ioc_create_icq(struct request_queue *q, gfp_t gfp_mask)
 	return icq;
 }
 
-void ioc_set_icq_flags(struct io_context *ioc, unsigned int flags)
+static void ioc_set_icq_flags(struct io_context *ioc, unsigned int flags)
 {
 	struct io_cq *icq;
 	struct hlist_node *n;
