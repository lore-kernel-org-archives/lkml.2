Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789Ab1EZM4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 08:56:41 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44034 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757672Ab1EZM4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 08:56:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ULWHSob7nPp38H53pckAnKjz1KQw3J9s4kmFQPcHRXDmZjbsAUYuk3smIfGwZ/Jdtr
         buCo1QMyPZOYyTZ2o5ULkMbzK+f81Bd2Q/lZSRAD0jzWH4drjPjZwgiRGTRfm/TWay5b
         Rm+eAyhCNSeqBuKd7W5634cHLe/nPam/+9ZTI=
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] brd: fix comment on initial device creation
Date: Thu, 26 May 2011 21:55:56 +0900
Message-Id: <1306414557-2441-5-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1306414557-2441-1-git-send-email-namhyung@gmail.com>
References: <1306414557-2441-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If 'rd_nr' param was not specified, 16 (can be adjusted via
CONFIG_BLK_DEV_RAM_COUNT) devices would be created by default
but comment said 1. Fix it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/block/brd.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index b1efa8f9ff42..d904d0da2928 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -571,10 +571,10 @@ static int __init brd_init(void)
 	 *
 	 * (1) if rd_nr is specified, create that many upfront, and this
 	 *     also becomes a hard limit.
-	 * (2) if rd_nr is not specified, create 1 rd device on module
-	 *     load, user can further extend brd device by create dev node
-	 *     themselves and have kernel automatically instantiate actual
-	 *     device on-demand.
+	 * (2) if rd_nr is not specified, create CONFIG_BLK_DEV_RAM_COUNT
+	 *     (default 16) rd device on module load, user can further
+	 *     extend brd device by create dev node themselves and have
+	 *     kernel automatically instantiate actual device on-demand.
 	 */
 
 	part_shift = 0;
-- 
1.7.5.2

