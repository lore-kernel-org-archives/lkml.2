Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab1E0NLh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 09:11:37 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61409 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab1E0NLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 09:11:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rD7+fe9lBxj3jJDd5c88Ovap7njXppssoG7eji2T/NA1t/RjLA/U9FTFMwoyBzTOFU
         DiUfDLMY3MJ+Ap6nBKd5/J20G2a0h3nAnqG8+Gqg90bWV0X+QEIk3987D7cvHD1pOu97
         kjyd1BKCLtT3+f7CWnlcsLAozMyyC0iEvJMKo=
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@nokia.com>
Subject: [PATCH 2/2] block: add REQ_SECURE to REQ_COMMON_MASK
Date: Fri, 27 May 2011 22:11:23 +0900
Message-Id: <1306501883-23498-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1306501883-23498-1-git-send-email-namhyung@gmail.com>
References: <1306501883-23498-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add REQ_SECURE flag to REQ_COMMON_MASK so that
init_request_from_bio() can pass it to @req->cmd_flags.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Adrian Hunter <adrian.hunter@nokia.com>
---
I couldn't find where the flag is passed from bio to req and don't know
how mmc - it seems that it's the only user of the flag, AFAICS - works
by now. Maybe I'm missing something. :)

 include/linux/blk_types.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index be50d9e70a7d..acdb1436dc14 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -168,7 +168,7 @@ enum rq_flag_bits {
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
 #define REQ_COMMON_MASK \
 	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_DISCARD | \
-	 REQ_NOIDLE | REQ_FLUSH | REQ_FUA)
+	 REQ_NOIDLE | REQ_FLUSH | REQ_FUA | REQ_SECURE)
 #define REQ_CLONE_MASK		REQ_COMMON_MASK
 
 #define REQ_RAHEAD		(1 << __REQ_RAHEAD)
-- 
1.7.5.2

