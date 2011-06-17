Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab1FQDML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 23:12:11 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45576 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682Ab1FQDMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 23:12:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=W5a5+DsdpAbctz+APZ2qW0bxT1OvDBzvKlJkcRCe8yhEobjQE6mMZ/Eoq1i6WAhdny
         oLXVYRUAjIIQu8zWvWnENjqEGYTWKrs89nGH3r50NM8Hua19Nxf5G47ews1NoW9c+rmg
         h9Ndl7uQyD84j3+1aC2hTEcjoyyCCBrQUeQ14=
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH reRESEND] block: add REQ_SECURE to REQ_COMMON_MASK
Date: Fri, 17 Jun 2011 12:12:00 +0900
Message-Id: <1308280320-3510-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1308278608-3284-1-git-send-email-namhyung@gmail.com>
References: <1308278608-3284-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add REQ_SECURE flag to REQ_COMMON_MASK so that
init_request_from_bio() can pass it to @req->cmd_flags.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
Send it again due to Adrian's mail delivery failure.

 include/linux/blk_types.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 2a7cea53ca0d..6395692b2e7a 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -167,7 +167,7 @@ enum rq_flag_bits {
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
 #define REQ_COMMON_MASK \
 	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_DISCARD | \
-	 REQ_NOIDLE | REQ_FLUSH | REQ_FUA)
+	 REQ_NOIDLE | REQ_FLUSH | REQ_FUA | REQ_SECURE)
 #define REQ_CLONE_MASK		REQ_COMMON_MASK
 
 #define REQ_RAHEAD		(1 << __REQ_RAHEAD)
-- 
1.7.5.2

